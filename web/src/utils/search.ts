import { ref } from "vue"

const query = ref("")

export const useSearch = () => {
    return {
        query,
    }
}
