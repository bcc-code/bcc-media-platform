import {SourceStrings } from "@crowdin/crowdin-api-client";
import {enabled, getConfig, getCredentials} from "./config";
import {getTranslationsFromEvent} from "./source";

export type Model = "show" | "season" | "episode";
export type Collection = "shows_translations" | "seasons_translations" | "episodes_translations";

export interface Event<T> {
    key: number;
    keys: (number|string)[]
    payload: T;
    collection: Collection;
}

export default ({_, action}) => {
    if (!enabled()) 
        return
    
    action('items.create', async (input: Event<any>) => {
        if (input.collection.endsWith("_translations")) {
            console.log(JSON.stringify(input))
            const config = getConfig();
            const {model, id, values} = getTranslationsFromEvent(input)

            const stringApi = new SourceStrings(getCredentials())
            for (const [field, value] of Object.entries(values)) {
                const identifier = `${model}-${id}-` + field;
                await stringApi.addString(config.projectId, {
                    fileId: config.contentFileId,
                    text: value,
                    identifier: identifier,
                })
            }
        }
    })

    action('items.update', async (input: Event<any>) => {
        if (input.collection.endsWith("_translations")) {
            console.log(JSON.stringify(input))
            const config = getConfig();
            const {model, id, values} = getTranslationsFromEvent(input)

            const stringApi = new SourceStrings(getCredentials())
            const strings = await stringApi.listProjectStrings(config.projectId)

            for (const [field, value] of Object.entries(values)) {
                const identifier = `${model}-${id}-` + field;
                const existingString = strings.data.find(s => s.data.identifier === identifier)

                if (existingString) {
                    await stringApi.editString(config.projectId, existingString.data.id, [
                        {
                            op: "replace",
                            path: "/text",
                            value: value
                        }
                    ])
                } else {
                    await stringApi.addString(config.projectId, {
                        fileId: config.contentFileId,
                        text: value,
                        identifier: `${model}-${id}-` + field,
                    })
                }
            }
        }
    })
}