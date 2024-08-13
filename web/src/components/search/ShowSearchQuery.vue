<script lang="ts" setup>
import Image from "@/components/Image.vue"
import breakpoints from "@/components/sections/item/breakpoints"
import { SearchQuery } from "@/graph/generated"
import { analytics } from "@/services/analytics"
import { goToShow } from "@/utils/items"
import { Navigation } from "swiper/modules"
import { Swiper, SwiperSlide } from "swiper/vue"
import { reactive } from "vue"
import { useI18n } from "vue-i18n"
import VButton from "../VButton.vue"

const { t } = useI18n()

const props = defineProps<{
    queryString: string
    result: SearchQuery
}>()

const modules = [Navigation]

const loading = reactive<Record<string, boolean>>({})

const onclick = async (index: number, id: string) => {
    analytics.track("searchresult_clicked", {
        elementId: id,
        elementType: "Show",
        group: "shows",
        elementPosition: index,
        searchText: props.queryString,
    })

    goToShow(id)
}

const adminOn = localStorage.getItem("admin") === "true"

const open = (id: string) => {
    window.open("https://admin.brunstad.tv/admin/content/shows/" + id)
}
</script>

<template>
    <div>
        <h2
            class="text-style-title-1 font-medium mb-2"
            :class="{
                hidden: result.search.result.length === 0,
            }"
        >
            {{ t("search.programs") }}
        </h2>
        <Swiper
            :slides-per-view="1"
            :space-between="20"
            :slides-per-group="1"
            :modules="modules"
            :breakpoints="breakpoints('medium')"
            navigation
        >
            <SwiperSlide v-for="(item, index) in result.search.result">
                <div
                    class="cursor-pointer"
                    @click="onclick(index, item.id)"
                    :class="[loading[item.id] ? 'opacity-50' : '']"
                >
                    <div class="relative mb-1 rounded-lg overflow-hidden">
                        <VButton
                            v-if="adminOn"
                            class="absolute top-2 right-2"
                            size="thin"
                            color="secondary"
                            @click="open(item.id)"
                        >
                            EDIT
                        </VButton>
                        <Image
                            :key="item.image ?? index"
                            :src="item.image"
                            :ratio="9 / 16"
                            size-source="width"
                        />
                    </div>
                    <p class="mt-1 text-md lg:text-xl">{{ item.title }}</p>
                </div>
            </SwiperSlide>
        </Swiper>
    </div>
</template>
