import { ref } from "vue"

const current = ref("unknown")

const setCurrent = (code: string) => {
    current.value = code
}

export const usePage = () => ({
    current,
    setCurrent,
})
