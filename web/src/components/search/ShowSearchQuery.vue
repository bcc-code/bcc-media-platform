<template>
    <div>
        <h1 class="text-xl font-semibold text-primary mb-2" :class="{
            'hidden': result.length === 0,
        }">Shows</h1>
        <Swiper
            :slides-per-view="1"
            :space-between="10"
            :slides-per-group="1"
            :modules="modules"
            :breakpoints="breakpoints"
            navigation
        >
            <SwiperSlide v-for="item in result">
                <SearchItem :item="item"> </SearchItem>
            </SwiperSlide>
        </Swiper>
    </div>
</template>
<script lang="ts" setup>
import { useSearchQuery } from "@/graph/generated"
import { computed, ref, watch } from "vue"
import { Swiper, SwiperSlide } from "swiper/vue"
import { Navigation } from "swiper"
import SearchItem from "./SearchItem.vue"

const props = defineProps<{
    query: string
    pause: boolean
}>()

const queryString = ref(props.query)

const { data, pause, resume } = useSearchQuery({
    pause: props.pause,
    variables: {
        query: queryString,
        type: "show",
    },
})

watch(
    () => props.query,
    () => {
        queryString.value = props.query
    }
)

watch(
    () => props.pause,
    () => {
        if (props.pause) {
            pause()
        } else {
            resume()
        }
    }
)

const result = computed(() => {
    return data.value?.search.result ?? []
})

const modules = [Navigation]

const breakpoints = {
    // when window width is >= 320px
    320: {
        slidesPerView: 2,
        spaceBetween: 10,
        slidesPerGroup: 2,
    },
    // when window width is >= 480px
    480: {
        slidesPerView: 3,
        spaceBetween: 15,
        slidesPerGroup: 3,
    },
    // when window width is >= 640px
    640: {
        slidesPerView: 4,
        spaceBetween: 20,
        slidesPerGroup: 4,
    },
    1200: {
        slidesPerView: 4,
        spaceBetween: 20,
        slidesPerGroup: 8,
    },
}
</script>
