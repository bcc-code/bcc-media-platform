import { Credentials } from "@crowdin/crowdin-api-client";

export function getConfig(): {
    projectId: number;
    contentFileId: number;
} {
    return {
        projectId: parseInt(process.env.CROWDIN_PROJECT_ID),
        contentFileId: parseInt(process.env.CROWDIN_CONTENT_FILE_ID),
    }
}

export function getCredentials(): Credentials {
    return {
        token: process.env.CROWDIN_TOKEN
    }
}

export function enabled(): boolean {
    return process.env.CROWDIN_ENABLED === "true"
}
