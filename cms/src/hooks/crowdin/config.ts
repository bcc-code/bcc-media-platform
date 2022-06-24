import { Credentials } from "@crowdin/crowdin-api-client";

export function getConfig(): {
    projectId: number;
    directoryId: number;
} {
    return {
        projectId: parseInt(process.env.CROWDIN_PROJECT_ID),
        directoryId: parseInt(process.env.CROWDIN_DIRECTORY_ID),
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
