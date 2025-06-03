import { ref } from 'vue'
import { RouteLocationRaw } from 'vue-router'
import { useSessionId } from '@/composables/useSessionId'
import { generateUUID } from './uuid'

const query = ref('')
const oldPath = ref(null as RouteLocationRaw | null)
const searchSessionId = ref(generateUUID())

export const useSearch = () => {
    const sessionId = useSessionId()

    return {
        query,
        oldPath,
        sessionId,
        searchSessionId
    }
}
