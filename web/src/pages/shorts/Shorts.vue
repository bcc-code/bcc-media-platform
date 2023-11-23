<script lang="ts" setup>
import Image from "@/components/Image.vue"
import { useGetShortDetailsQuery } from "@/graph/generated"

const props = defineProps<{
    shortId: string
}>()

const { data } = useGetShortDetailsQuery({
    variables: {
        id: props.shortId,
    },
})
</script>
<template>
    <section class="flex w-full p-4">
        <div
            class="mx-auto p-8 bg-background-2 flex flex-col gap-4 rounded-md max-w-screen-md w-full"
        >
            <div v-if="data">
                <Image
                    v-if="data.short.image"
                    :src="data.short.image"
                    size-source="width"
                />
                <h3 class="text-lg font-bold">{{ data?.short.title }}</h3>
                <p>{{ data?.short.description }}</p>
            </div>
            <div class="flex flex-col">
                <h3 class="font-bold">
                    {{ $t("shorts.watchOnOurApp") }}
                </h3>
                <div class="flex gap-2 mt-1">
                    <a href="https://apple.co/3VewzK9"
                        ><img src="/badges/app_store.png"
                    /></a>
                    <a
                        href="https://play.google.com/store/apps/details?id=tv.brunstad.app"
                        ><img src="/badges/google_play.png"
                    /></a>
                </div>
            </div>
        </div>
    </section>
</template>
