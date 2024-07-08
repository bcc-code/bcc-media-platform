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
        title: "A mentor at 15 years old? - Episode 1",
        images: [
            "https://imgix.bcc.media/27743d87-9107-4cda-88e0-beda3baff72f.png",
            "https://imgix.bcc.media/e2240dde-f0d7-446a-84f4-b747bd28c790.png",
            "https://imgix.bcc.media/2f14926e-a0cc-4f94-8193-3c970f0db3c5.png",
        ],
    },
    {
        id: "15yearmentor-2",
        title: "A mentor at 15 years old? - Episode 2",
        images: [
            "https://imgix.bcc.media/bd468d45-b0c1-4379-b23f-1b605761ae37.png",
            "https://imgix.bcc.media/8dd8ecce-2016-408f-92c5-caa71ef79278.png",
            "https://imgix.bcc.media/d91c1fed-b2e4-4a8b-8548-aa0abd6bafdf.png",
        ],
    },
    {
        id: "15yearmentor-3",
        title: "A mentor at 15 years old? - Episode 3",
        images: [
            "https://imgix.bcc.media/18268a0d-9fa1-448f-a073-d9f77990f96c.png",
            "https://imgix.bcc.media/16949bac-a7c6-489b-8947-13f1b513dcef.png",
            "https://imgix.bcc.media/9ef9e297-53b2-4457-a128-d949b0b1b6cd.png",
        ],
    },
    {
        id: "15yearmentor-4",
        title: "A mentor at 15 years old? - Episode 4",
        images: [
            "https://imgix.bcc.media/53d9f4ac-fc19-4c0a-8644-c81b1da1ce14.png",
            "https://imgix.bcc.media/2ba9e50c-9b31-42ef-bb6a-5a8f7582fd35.png",
            "https://imgix.bcc.media/19ee3b8e-7b4f-47f8-9fbd-5625f09673af.png",
            "https://imgix.bcc.media/28d24c47-8865-4fbe-89ef-e05cc735d9ba.png",
        ],
    },
    {
        id: "15yearmentor-5",
        title: "A mentor at 15 years old? - Episode 5",
        images: [
            "https://imgix.bcc.media/10fd1f21-621a-487f-9b66-9f1dd302b14c.png",
            "https://imgix.bcc.media/451ace85-45ac-4613-a581-a6337b907b9b.png",
        ],
    },
    {
        id: "15yearmentor-6",
        title: "A mentor at 15 years old? - Episode 6",
        images: [
            "https://imgix.bcc.media/f3f66250-ff04-4574-ba09-eb6e455f34b0.png",
            "https://imgix.bcc.media/823eb03f-a944-4404-8994-90083588102c.png",
            "https://imgix.bcc.media/823eb03f-a944-4404-8994-90083588102c.png",
        ],
    },
    {
        id: "15yearmentor-7",
        title: "A mentor at 15 years old? - Episode 7",
        images: [
            "https://imgix.bcc.media/d51ec4aa-94f3-4e95-ab31-928ff2fcc721.png",
            "https://imgix.bcc.media/4020035c-414d-457e-b581-42880031b3f0.png",
        ],
    },
    {
        id: "15yearmentor-8",
        title: "A mentor at 15 years old? - Episode 8",
        images: [
            "https://imgix.bcc.media/dc323ca3-3e28-4f41-8ecf-25a19064e867.png",
            "https://imgix.bcc.media/0fa88db7-42c8-40dc-adfe-265b83093d44.png",
            "https://imgix.bcc.media/5ac0256e-9343-40b3-a492-c50b54121d00.png",
        ],
    },
    {
        id: "15yearmentor-9",
        title: "A mentor at 15 years old? - Episode 9",
        images: [
            "https://imgix.bcc.media/f7230736-4c6d-4573-bd77-592596847ea2.png",
            "https://imgix.bcc.media/12ec4fe6-cfd6-46ed-98f2-85ec96f3ee91.png",
            "https://imgix.bcc.media/6ef3f3ca-040a-4f30-bcec-c2cfab8b3323.png",
        ],
    },
    {
        id: "15yearmentor-10",
        title: "A mentor at 15 years old? - Episode 10",
        images: [
            "https://imgix.bcc.media/7a8f2944-bd19-443d-af75-c1ae1be026fd.png",
            "https://imgix.bcc.media/0c1eb0ca-ee61-4b6f-b10e-a0b9aea904df.png",
            "https://imgix.bcc.media/61ca2530-983c-4c94-afe4-48017f922b86.png",
            "https://imgix.bcc.media/0f2ed079-a392-423f-9416-5492501a9cc3.png",
        ],
    },
    {
        id: "15yearmentor-11",
        title: "A mentor at 15 years old? - Episode 11",
        images: [
            "https://imgix.bcc.media/34ce472e-6f72-40d2-b087-a1fb49ee7a64.png",
            "https://imgix.bcc.media/2ae9af90-59fd-4e94-846c-dede67a832bb.png",
            "https://imgix.bcc.media/788196c0-ad43-4ba0-8d4f-2ed30ac78b9b.png",
            "https://imgix.bcc.media/5b8a73d5-3c2c-4cf5-a41b-df3eb19c7815.png",
            "https://imgix.bcc.media/3e45d7b0-e182-47bb-a823-8f6d10684792.png",
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
