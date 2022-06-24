import { SourceFiles, UploadStorage } from "@crowdin/crowdin-api-client";
import { getConfig, getCredentials } from "./config";

export async function createFile(collection: string, sources: {
    identifier: string;
    sourceString: string;
    context: string;
}[]) {
    const config = getConfig()
    const entries: string[] = []
    for (const source of sources) {
        entries.push([source.identifier, source.sourceString, source.context].map(i => JSON.stringify(i)).join(","))
    }
    const storageApi = new UploadStorage(getCredentials())
    const storage = await storageApi.addStorage(collection + ".csv", entries.join("\n"))
    
    const fileApi = new SourceFiles(getCredentials())
    const file = await fileApi.createFile(config.projectId, {
        name: collection + ".csv",
        storageId: storage.data.id,
        directoryId: config.directoryId,
        title: collection,
        type: "csv",
        importOptions: {
            importTranslations: true,
            scheme: {
                identifier: 0,
                sourceOrTranslation: 1,
                context: 2,
            } as any
        } as any
    })

    return file.data
}