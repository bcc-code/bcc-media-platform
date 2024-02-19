<template>
    <section>
        <div class="w-full lg:w-1/2">
            <div
                v-for="i in items.filter((i) => i.type === 'Episode')"
                class="flex p-2 gap-2 cursor-pointer border-l-4 border-red hover:bg-red hover:bg-opacity-10 hover:border-opacity-100 transition duration-200"
                :class="[
                    i.id === currentId
                        ? 'bg-red bg-opacity-20 hover:bg-opacity-20'
                        : 'border-opacity-0',
                    episodeComingSoon(i) ? 'pointer-events-none' : '',
                ]"
                @click="$emit('itemClick', i)"
                :key="i.id"
            >
                <div class="w-1/3">
                    <WithProgressBar
                        class="aspect-video text-xs"
                        :item="
                            i.duration == null
                                ? undefined
                                : {
                                      duration: i.duration,
                                      progress: i.progress,
                                      id: i.id,
                                  }
                        "
                    >
                        <Pill
                            class="absolute -top-1 -right-1 pointer-events-none"
                            v-if="episodeComingSoon(i)"
                            >{{ $t("episode.comingSoon") }}</Pill
                        >
                        <Image
                            v-if="i.image"
                            :src="i.image"
                            size-source="width"
                            class="rounded-lg"
                            :class="episodeComingSoon(i) ? 'opacity-50' : ''"
                            :ratio="9 / 16"
                        />
                    </WithProgressBar>
                </div>
                <div
                    class="w-2/3 ml-4"
                    :class="episodeComingSoon(i) ? 'opacity-50' : ''"
                >
                    <h1 class="text-style-title-3 line-clamp-2">
                        <span v-if="viewEpisodeNumber && i.number"
                            >{{ i.number }}. </span
                        >{{ i.title }}
                    </h1>
                    <AgeRating :episode="i" />
                    <div
                        class="hidden lg:flex mt-1.5 line-clamp-2 text-style-body-2 opacity-70"
                    >
                        <div
                            class="pointer-events-none"
                            v-html="
                                i.description ? mdToHTML(i.description) : ''
                            "
                        ></div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import Image from "../Image.vue"
import WithProgressBar from "@/components/episodes/WithProgressBar.vue"
import AgeRating from "../episodes/AgeRating.vue"
import { ListItem } from "@/utils/lists"
import Pill from "./item/Pill.vue"
import { comingSoon, episodeComingSoon } from "@/utils/items"
import { mdToHTML } from "@/services/converter"

defineProps<{
    items: ListItem[]
    currentId: string
    viewEpisodeNumber?: boolean
}>()

defineEmits<{
    (e: "itemClick", i: ListItem): void
}>()
</script>
