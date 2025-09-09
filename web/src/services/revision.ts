import { api } from '@/config'
import { useAuth } from './auth'

let revision: string | null = null

export const getRevision = async () => {
    if (revision) {
        return revision
    }
    try {
        const { getToken } = useAuth()
        const token = await getToken()
        const headers = token
            ? {
                headers: {
                    Authorization: 'Bearer ' + token,
                },
            }
            : {}
        const result = await fetch(api.url + '/versionz', headers)

        const rev = await result.json()

        if (rev['build_sha']) {
            return (revision = rev)
        }
    } catch { }
    return (revision = 'unknown | debug')
}
