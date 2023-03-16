<template>
    <div
        class="h-48 w-screen h-screen bg-[#FEECD0] z-50 text-[#422E1C] overflow-x-hidden overflow-y-hidden"
        :ref="(el) => (parentScrollEl = el as any)"
    >
        <template v-if="parentScrollEl != null">
            <Swiper
                :parallax="true"
                :scrollbar="false"
                :modules="[Mousewheel, Parallax]"
                ref="swiperEl"
                style="overflow: visible"
                :lazy="false"
                direction="vertical"
                :mousewheel="true"
                @swiper="onswipe"
                :auto-height="true"
                :speed="500"
            >
                <!--  <div
                    class="absolute top-0 left-0 w-[50vw] h-[50vh] bg-white"
                    data-swiper-parallax-y="100%"
                ></div> -->
                <SwiperSlide>
                    <Page1 :parent-scroll-el="parentScrollEl"></Page1>
                </SwiperSlide>
                <SwiperSlide>
                    <Page2 :parent-scroll-el="parentScrollEl"></Page2>
                </SwiperSlide>
            </Swiper>
        </template>
    </div>
</template>

<script lang="ts" setup>
import Auth from "@/services/auth"
import { onMounted, onUnmounted, ref } from "vue"
import SotmShapeLong from "./greeting/SotmShapeLong.vue"
import { init } from "@sentry/vue"
import Page1 from "./greeting/Page1.vue"
import Page2 from "./greeting/Page2.vue"
import Page3 from "./greeting/Page3.vue"
import Page4 from "./greeting/Page4.vue"

import TSwiper, {
    Navigation,
    Pagination,
    Parallax,
    Lazy,
    SwiperOptions,
    Mousewheel,
} from "swiper"
import { Swiper, SwiperSlide } from "swiper/vue"

const pages = [""]
const displayName = ref("")
const parentScrollEl = ref<Element | null>(null)
const targetScrollEl = ref<Element | null>(null)
const targetScrollEl2 = ref<Element | null>(null)

const onswipe = (swiper: TSwiper) => {}

const getUserInfo = async () => {
    let res = await fetch("https://login2.bcc.no/userinfo", {
        headers: { Authorization: "Bearer " + (await Auth.getToken()) },
    })
    let response = await res.json()
    console.log(response)
    displayName.value = response.given_name
}

getUserInfo()

const animate = (ratio: number) => (diff: number) => {
    console.log(diff)
    return `transform: translate(0, ${-diff * ratio}px);`
}
</script>
