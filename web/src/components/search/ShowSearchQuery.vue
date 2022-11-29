<template>
    <div>
        <h1
            class="text-2xl font-medium mb-2"
            :class="{
                hidden: result.length === 0,
            }"
        >
            {{ t("search.programs") }}
        </h1>
        <Swiper
            :slides-per-view="1"
            :space-between="10"
            :slides-per-group="1"
            :modules="modules"
            :breakpoints="breakpoints('medium')"
            navigation
        >
            <SwiperSlide v-for="i, index in result">
                <div
                    class="cursor-pointer mx-2"
                    @click="onclick(index, i.id)"
                    :class="[loading[i.id] ? 'opacity-50' : '']"
                >
                    <div class="relative mb-1">
                        <img
                            :id="i.id"
                            :src="
                                i.image +
                                `?h=${225}&w=${450}&fit=crop&crop=faces`
                            "
                            loading="lazy"
                            class="rounded-md top-0 w-full object-cover aspect-video"
                        />
                    </div>
                    <div class="mt-1">
                        <h1 class="text-md lg:text-xl">{{ i.title }}</h1>
                    </div>
                </div>
            </SwiperSlide>
        </Swiper>
    </div>
</template>
<script lang="ts" setup>
import { useGetDefaultEpisodeIdQuery, useSearchQuery } from "@/graph/generated"
import { computed, nextTick, ref, watch } from "vue"
import { Swiper, SwiperSlide } from "swiper/vue"
import { Navigation } from "swiper"
import { useI18n } from "vue-i18n"
import { goToEpisode } from "@/utils/items"
import breakpoints from "../sections/item/breakpoints"
import { analytics } from "@/services/analytics"

const { t } = useI18n()

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

const showId = ref("")

const { data: getDefaultId, executeQuery } = useGetDefaultEpisodeIdQuery({
    pause: true,
    variables: {
        showId,
    },
})

const loading = ref(
    {} as {
        [key: string]: boolean | undefined
    }
)

const onclick = async (index: number, id: string) => {
    analytics.track("searchresult_clicked", {
        elementId: id,
        elementType: "Show",
        group: "shows",
        elementPosition: index.toString(),
        searchText: queryString.value
    })

    showId.value = id
    loading.value[id] = true
    await nextTick()

    await executeQuery()

    if (getDefaultId.value?.show.defaultEpisode) {
        goToEpisode(getDefaultId.value.show.defaultEpisode.id)
    }
}
</script>
