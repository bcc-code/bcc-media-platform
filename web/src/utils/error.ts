import { ref } from 'vue'

export type Error = {
    id: number
    title: string
}

export const errors = ref([] as Error[])

export const addError = (error: string) => {
    const id = Math.floor(Math.random() * 1000)
    errors.value.push({
        id,
        title: error,
    })

    setTimeout(() => {
        errors.value = errors.value.filter((i) => i.id !== id)
    }, 5000)
}

export const removeError = (index: number) => {
    errors.value = errors.value.filter((_, i) => i !== index)
}
