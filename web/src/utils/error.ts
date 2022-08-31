import { ref } from "vue"

export type Error = {
    title: string
}

export const errors = ref([] as Error[])

export const addError = (error: string) => {
    errors.value.push({
        title: error,
    })
}

export const removeError = (index: number) => {
    errors.value = errors.value.filter((_, i) => i !== index)
}
