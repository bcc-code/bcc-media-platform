<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from "vue"
import Image from "@/components/Image.vue"
import ComicImage from "./ComicImage.vue"
import VButton from "../VButton.vue"
import { analytics } from "@/services/analytics"
import { useAuth } from "@/services/auth"
import { useGetMeQuery } from "@/graph/generated"

const props = defineProps<{
    comicId: string
}>()

const comics = [
    {
        id: "15yearmentor-1",
        title: "15 år og mentor? - Del 1",
        images: [
            "https://imgix.bcc.media/27743d87-9107-4cda-88e0-beda3baff72f.png",
            "https://imgix.bcc.media/e2240dde-f0d7-446a-84f4-b747bd28c790.png",
            "https://imgix.bcc.media/2f14926e-a0cc-4f94-8193-3c970f0db3c5.png",
        ],
    },
]

const comic = ref(
    comics.find((comic) => comic.id === props.comicId) || comics[0]
)

const analyticsQuery = useGetMeQuery({
    pause: true,
})
const { authenticated } = useAuth()

const fractionRead = ref(0)
const comicRef = ref<HTMLElement | null>(null)

const calculatePercentRead = () => {
    // calculate percent , taking into account the comicRef height (dynamic), excluding the footer and anything like that.
    // the scroll comes from the document
    if (comicRef.value) {
        const scrollTop = document.documentElement.scrollTop
        const windowSize = window.innerHeight
        const comicTop = comicRef.value.offsetTop
        const comicHeight = comicRef.value.offsetHeight
        const comicBottom = comicTop + comicHeight
        const visibleTop = Math.max(comicTop, scrollTop)
        const visibleBottom = Math.min(comicBottom, scrollTop + windowSize)
        let fraction = visibleBottom / comicBottom
        if (visibleTop <= comicTop) {
            fraction = 0
        }
        fractionRead.value = fraction
    }
}

onMounted(async () => {
    await analytics.initialize(async () => {
        let analyticsId: string | null = null
        const result = await analyticsQuery.executeQuery()
        if (result.data.value?.me.analytics.anonymousId) {
            analyticsId = result.data.value.me.analytics.anonymousId
        }
        return analyticsId
    })

    console.log("ag: initialized analytics")

    analytics.page({
        id: "comic",
        title: "Comic - " + props.comicId,
        meta: {
            comicId: props.comicId,
        },
    })

    document.body.onscroll = calculatePercentRead

    setInterval(() => {
        analytics.track("viewing", {
            elementType: "comic",
            pageCode: "comic",
            elementId: props.comicId,
            meta: {
                fractionRead: fractionRead.value,
            },
        })
    }, 5000)
})
</script>

<template>
    <div
        class="inline-flex flex-col items-center justify-start w-full h-full relative"
    >
        <h2
            class="text-style-headline-2 pb-8 pt-8 px-4 bg-background-1 w-full text-center anim-slide ease-out-expo"
        >
            {{ comic.title }}
        </h2>
        <div class="w-full" ref="comicRef">
            <ComicImage
                v-for="image in comic.images"
                :key="image"
                :url="image"
            />
        </div>
        <div
            class="mt-8 flex items-center justify-center flex-col bg-background-2 rounded-lg px-8 py-8 mx-4"
        >
            <h3 class="text-style-title-2 text-center">
                Subscribe to get notified about new comics!
            </h3>
            <VButton
                class="mt-4"
                variant="primary"
                @click="console.log('Subscribe')"
            >
                Subscribe
            </VButton>
        </div>
        <div class="h-64">&nbsp;</div>
        <div class="h-64">&nbsp;</div>
        <div class="h-64">&nbsp;</div>

        <div
            class="fixed top-0 -mt-[1px] left-0 h-2 rounded-r-lg text-label-1 bg-background-1 opacity-50 transform-gpu"
            :style="{ width: `${fractionRead * 100}%` }"
        ></div>
    </div>
</template>

<style scoped>
.anim-slide {
    animation: slide 3s;
}

@keyframes slide {
    0% {
        opacity: 0;
        transform: translateY(-10%);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>
