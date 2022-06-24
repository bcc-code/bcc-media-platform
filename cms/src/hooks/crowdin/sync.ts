import { ProjectsGroups, SourceFiles, SourceStrings, SourceStringsModel, StringTranslations, StringTranslationsModel } from "@crowdin/crowdin-api-client";
import axios from "axios";
import knex from "knex";
import { getPrimaryLanguageKey } from ".";
import { enabled, getConfig, getCredentials } from "./config";
import { createFile } from "./file";

type Translation = {
    id: number;
    parentId: number;
    collection: string;
    language: string;
    title: string;
    description: string | null;
    primary: boolean;
}

const db = knex({
    client: "pg",
    connection: {
        connectionString: process.env.DB_CONNECTION_STRING,
    }
})

async function getTranslations(collection: string) {
    const queryResult = await db.raw("SELECT * FROM " + collection + "_translations");

    const translations: Translation[] = []

    for (const row of queryResult.rows) {
        const id = row.id as number
        const parentId = row[collection + "_id"] as number
        const language = row.languages_code as string
        const title = row.title as string | null
        const description = row.description as string | null
        const primary = row.is_primary as boolean

        translations.push({
            id,
            parentId,
            collection,
            language,
            title,
            description,
            primary,
        })
    }

    return translations
}

export async function sync() {
    if (!enabled()) {
        return
    }

    const config = getConfig()
    const fileApi = new SourceFiles(getCredentials())
    const translationApi = new StringTranslations(getCredentials())
    const stringsApi = new SourceStrings(getCredentials())

    const files = await fileApi.listProjectFiles(config.projectId, {
        directoryId: config.directoryId,
    })
    const project = await (new ProjectsGroups(getCredentials())).getProject(config.projectId)

    for (const collection of ["shows", "seasons", "episodes"]) {
        console.log("Syncing translations for collection: " + collection)
        const existingTranslations = await getTranslations(collection)

        console.log("Existing translations: " + existingTranslations.length)

        const file = (files.data.find(f => f.data.title === collection))?.data
        if (!file) {
            console.log("Creating file for collection: " + collection)
            await createFile(collection, existingTranslations.filter(e => e.language === getPrimaryLanguageKey()).reduce((a, b) => {
                a.push({
                    identifier: collection + "-" + b.parentId + "-title",
                    context: "",
                    sourceString: b.title
                })
                if (b.description) {
                    a.push({
                        identifier: collection + "-" + b.parentId + "-description",
                        context: "",
                        sourceString: b.description
                    })
                }
                return a
            }, [] as {
                identifier: string;
                sourceString: string;
                context: string;
            }[]))

            continue;
        }

        let missingTranslationIdentifiers = existingTranslations.filter(l => l.language === getPrimaryLanguageKey()).reduce((a, b) => {
            a.push(collection + "-" + b.parentId + "-title")
            if (b.description) {
                a.push(collection + "-" + b.parentId + "-description")
            }
            return a;
        }, [] as string[])

        let resultLength = 0;
        let offset = 0;
        const limit = 100;
        const stringsById: {
            [key: string]: SourceStringsModel.String
        } = {}

        do {
            const strings = await stringsApi.listProjectStrings(config.projectId, {
                fileId: file.id,
                limit: limit,
                offset: offset,
            });

            for (const string of strings.data) {
                stringsById[string.data.id] = string.data;
                missingTranslationIdentifiers = missingTranslationIdentifiers.filter(i => i !== string.data.identifier)
            }

            resultLength = strings.data.length;

            offset += limit
        } while(resultLength === limit)

        console.log("Retrieved strings: " + Object.keys(stringsById).length)

        console.log("Missing strings from file: " + missingTranslationIdentifiers.length)

        if (missingTranslationIdentifiers.length > 0) {
            for (const t of missingTranslationIdentifiers) {
                const [_, stringId, field] = t.split("-")
                const id = parseInt(stringId)
                const translation = existingTranslations.find(i => i.id === id)
                console.log("Adding string for identifier: " + t)
                await stringsApi.addString(config.projectId, {
                    text: translation[field],
                    identifier: t,
                    fileId: file.id
                })
            }
        }

        let missingTranslations: Translation[] = []
        const pushMissingTranslations = async (force = false) => {
            if (missingTranslations.length > limit || (force && missingTranslations.length)) {
                console.log("Inserting translations for collection " + collection)
                await db.raw("INSERT INTO " + collection + "_translations (title, description, languages_code, " + collection + "_id) VALUES ('" + missingTranslations.map(i => [i.title, i.description, i.language].map(i => i?.replace("'", "\'") ?? null).join("','") + "', '" + i.parentId).join("'), ('") + "')")
                missingTranslations = []
            }
        }
        let updateTranslations: Translation[] = []
        const pushUpdateTranslations = async (force = false) => {
            if (updateTranslations.length > limit || (force && missingTranslations.length)) {
                console.log("Updating translations for collection " + collection)
                for (const translation of updateTranslations) {
                    await db.raw("UPDATE " + collection + " SET title = " + JSON.stringify(translation.title) + ", description = " + JSON.stringify(translation.description) + " WHERE id = " + translation.id)
                }
                updateTranslations = []
            }
        }

        for (const language of project.data.targetLanguages) {
            let resultLength = 0;
            let offset = 0;

            const existingLanguageTranslations = existingTranslations.filter(i => i.language === language.id)

            do {
                console.log("Retrieving approvals.")
                const approvals = await translationApi.listTranslationApprovals(config.projectId, {
                    fileId: file.id,
                    languageId: language.id,
                })

                resultLength = approvals.data.length
                offset += limit

                
                const stringIds = approvals.data.map(i => i.data.stringId).join(",");
                if (!stringIds) {
                    continue;
                }
                console.log("Retrieving translations for the approvals")
                const translations = await translationApi.listLanguageTranslations(config.projectId, language.id, {
                    stringIds,
                })

                const items: (Translation & {changed: boolean})[] = [];
                for (const translation of translations.data) {
                    const string = stringsById[translation.data.stringId.toString()]
                    if (!string) {
                        console.log("Missing string for translation");
                        console.log(translation.data)
                    }
                    const [_, itemId, field] = string.identifier.split("-")
                    const parentId = parseInt(itemId)
                    let item = items.find(i => i.parentId === parentId)
                    if (!item) {
                        const existingItem = (existingLanguageTranslations.find(i => i.parentId === parentId))
                        if (!existingItem) {
                            item = {
                                collection,
                                id: 0,
                                description: null,
                                title: "",
                                language: language.id,
                                parentId: parseInt(itemId),
                                primary: false,
                                changed: false,
                            }
                        } else {
                            item = Object.assign({changed: false}, existingItem)
                        }
                        items.push(item)
                    }
                    const value = (translation.data as StringTranslationsModel.PlainLanguageTranslation).text
                    if (item[field] !== value) {
                        item[field] = value
                        item.changed = true
                    }
                }
                for (const item of items) {
                    if (item.changed) {
                        if (item.id !== 0) {
                            updateTranslations.push(item);
                        } else {
                            missingTranslations.push(item)
                        }
                    }
                }
                await pushMissingTranslations();
                await pushUpdateTranslations();
            } while (resultLength === limit)

            await pushMissingTranslations(true);
            await pushUpdateTranslations(true);
        }
        console.log("Completed sync for collection: " + collection)
    }
    console.log("Completed sync")
}