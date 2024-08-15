import { ref } from 'vue'
import { RouteLocationRaw } from 'vue-router'

const query = ref('')

const oldPath = ref(null as RouteLocationRaw | null)

export const useSearch = () => {
    return {
        query,
        oldPath,
    }
}
