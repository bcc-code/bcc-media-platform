<template>
    <section class="w-full h-screen relative">
        <div
            class="flex items-center justify-center w-full h-full absolute"
            v-if="fetching || !iframeLoaded"
        >
            <Loader variant="spinner" />
        </div>
        <div v-if="error" class="m-8">{{ error.message }}</div>
        <iframe
            v-if="data?.redirect.url"
            ref="frame"
            class="w-full h-full"
            :src="data?.redirect.url"
            @load="iframeLoaded = true"
            allowtransparency
            allowfullscreen
            frameborder="0"
        ></iframe>
    </section>
</template>
<script lang="ts" setup>
import Loader from "@/components/Loader.vue"
import { useGetRedirectUrlQuery } from "@/graph/generated"
import { ref } from "vue"

const props = defineProps<{ code: string }>()
const iframeLoaded = ref(false)

const { data, error, fetching } = useGetRedirectUrlQuery({
    variables: {
        code: props.code,
    },
})
</script>
