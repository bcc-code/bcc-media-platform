import { api } from "@/config"

let revision: string | null = null

export const getRevision = async () => {
    if (revision) {
        return revision
    }
    try {
        const result = await fetch(api.url + "/versionz")
        const rev = await result.json()

        if (rev["build_sha"]) {
            return (revision = rev as string)
        }
    } catch {}
    return (revision = "unknown | debug")
}
