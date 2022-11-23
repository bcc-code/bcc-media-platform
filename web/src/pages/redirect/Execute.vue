<template>
    <div v-if="error" class="flex flex-col">
        <p class="mx-auto text-lg mt-40">Invalid code</p>
    </div>
</template>
<script lang="ts" setup>
import { useGetRedirectUrlQuery } from "@/graph/generated"

const props = defineProps<{ code: string }>()

const { then, error } = useGetRedirectUrlQuery({
    variables: {
        code: props.code,
    },
})

then((result) => {
    const url = result.data.value?.redirect.url
    if (url) {
        window.location.replace(url)
    }
})
</script>
