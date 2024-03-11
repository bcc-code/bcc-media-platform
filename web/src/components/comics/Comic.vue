<script setup lang="ts">
import { ref, onMounted, watch } from "vue"
import Image from "@/components/Image.vue"
import ComicImage from "./ComicImage.vue"
import VButton from "../VButton.vue"
import { analytics } from "@/services/analytics"
import { useAuth } from "@/services/auth"
import { SubscriptionTopic, useGetMeQuery } from "@/graph/generated"
import SubscribeButton from "./SubscribeButton.vue"
import { useIntervalFn } from "@vueuse/core"

const props = defineProps<{
    comicId: string
}>()

const comics = [
    {
        id: "15yearmentor-1",
        title: "A mentor at 15 years old? - Part 1:1",
        images: [
            "https://imgix.bcc.media/27743d87-9107-4cda-88e0-beda3baff72f.png",
            "https://imgix.bcc.media/e2240dde-f0d7-446a-84f4-b747bd28c790.png",
            "https://imgix.bcc.media/2f14926e-a0cc-4f94-8193-3c970f0db3c5.png",
        ],
    },
    {
        id: "15yearmentor-2",
        title: "A mentor at 15 years old? - Part 1:2",
        images: [
            "https://imgix.bcc.media/bd468d45-b0c1-4379-b23f-1b605761ae37.png",
            "https://imgix.bcc.media/8dd8ecce-2016-408f-92c5-caa71ef79278.png",
            "https://imgix.bcc.media/d91c1fed-b2e4-4a8b-8548-aa0abd6bafdf.png",
        ],
    },
]

const comic = ref(
    comics.find((comic) => comic.id === props.comicId) || comics[0]
)

const { authenticated } = useAuth()

const currentFraction = ref(0)
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
        currentFraction.value = fraction
    }
}

onMounted(async () => {
    document.body.onscroll = calculatePercentRead

    analytics.page({
        id: "comic",
        title: "Comic - " + props.comicId,
        meta: {
            comicId: props.comicId,
        },
    })
})

const trackViewing = () => {
    analytics.track("viewing", {
        elementType: "Comic",
        pageCode: "comic",
        elementId: props.comicId,
        meta: {
            currentFraction: currentFraction.value,
        },
    })
}

const hasSentFraction1 = ref(false)
const startTime = ref<number | undefined>(undefined)
watch(currentFraction, () => {
    if (!startTime.value && currentFraction.value > 0) {
        startTime.value = Date.now()
    }
    if (hasSentFraction1.value) return
    if (currentFraction.value !== 1) return
    hasSentFraction1.value = true

    analytics.track("interaction", {
        contextElementType: "Comic",
        contextElementId: props.comicId,
        interaction: "comic_done",
        meta: {
            timeToReadSec: (Date.now() - startTime.value!) / 1000,
        },
    })
})
useIntervalFn(trackViewing, 15 * 1000)

const trackSubscribeClick = () => {
    analytics.track("interaction", {
        contextElementType: "Comic",
        contextElementId: props.comicId,
        interaction: "subscribe",
    })
}
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
        <div class="w-full justify-center" ref="comicRef">
            <ComicImage
                v-for="image in comic.images"
                :key="image"
                :url="image"
            />
        </div>
        <div
            class="mt-8 flex items-center justify-center flex-col bg-background-2 rounded-2xl px-8 py-8 mx-4"
        >
            <h3 class="text-style-title-2 text-center">
                Subscribe to get notified about new comics!
            </h3>
            <SubscribeButton
                class="mt-4"
                :topic="SubscriptionTopic.Comics"
                @click="trackSubscribeClick"
            />
        </div>
        <div class="h-96 mt-48">&nbsp;</div>

        <div
            class="fixed top-0 -mt-[1px] left-0 h-2 rounded-r-lg text-label-1 bg-background-1 opacity-50 transform-gpu"
            :style="{ width: `${currentFraction * 100}%` }"
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
