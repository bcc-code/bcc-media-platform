<template>
    <div>
        <h1
            class="text-2xl font-medium mb-2"
            :class="{
                hidden: result.search.result.length === 0,
            }"
        >
            {{ t("search.programs") }}
        </h1>
        <Swiper
            :slides-per-view="1"
            :space-between="20"
            :slides-per-group="1"
            :modules="modules"
            :breakpoints="breakpoints('medium')"
            navigation
        >
            <SwiperSlide v-for="(i, index) in result.search.result">
                <div
                    class="cursor-pointer"
                    @click="onclick(index, i.id)"
                    :class="[loading[i.id] ? 'opacity-50' : '']"
                >
                    <div class="relative mb-1 rounded-lg overflow-hidden">
                        <div
                            v-if="adminOn"
                            class="absolute text-primary right-0 bg-black p-2 rounded cursor-pointer m-2"
                            @click="open(i)"
                        >
                            EDIT
                        </div>
                        <Image
                            :key="i.image ?? index"
                            :src="i.image"
                            :ratio="9 / 16"
                            size-source="width"
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
import { SearchQuery, useGetDefaultEpisodeIdQuery } from "@/graph/generated"
import { nextTick, ref } from "vue"
import { Swiper, SwiperSlide } from "swiper/vue"
import { Navigation } from "swiper/modules"
import { useI18n } from "vue-i18n"
import { goToEpisode } from "@/utils/items"
import breakpoints from "../sections/item/breakpoints"
import { analytics } from "@/services/analytics"
import Image from "../Image.vue"

const { t } = useI18n()

const props = defineProps<{
    queryString: string
    result: SearchQuery
}>()

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
        elementPosition: index,
        searchText: props.queryString,
    })

    showId.value = id
    loading.value[id] = true
    await nextTick()

    await executeQuery()

    if (getDefaultId.value?.show.defaultEpisode) {
        goToEpisode(getDefaultId.value.show.defaultEpisode.id)
    }
}

const adminOn = localStorage.getItem("admin") === "true"

const open = (i: { id: string }) => {
    window.open("https://admin.brunstad.tv/admin/content/shows/" + i.id)
}
</script>
