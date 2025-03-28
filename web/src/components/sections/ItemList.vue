<script lang="ts" setup>
import WithProgressBar from '@/components/episodes/WithProgressBar.vue'
import Pill from '@/components/Pill.vue'
import { mdToHTML } from '@/services/converter'
import { episodeComingSoon } from '@/utils/items'
import { ListItem } from '@/utils/lists'
import AgeRating from '../episodes/AgeRating.vue'
import Image from '../Image.vue'
import { useI18n } from 'vue-i18n'

defineProps<{
    items: ListItem[]
    currentId: string
    viewEpisodeNumber?: boolean
}>()

defineEmits<{
    (e: 'itemClick', i: ListItem): void
}>()

const { t } = useI18n()
</script>

<template>
    <section>
        <div class="w-full">
            <div
                v-for="i in items.filter((i) => i.type === 'Episode')"
                :key="i.id"
                class="flex p-2 gap-2 cursor-pointer border-l-4 border-red hover:bg-red hover:bg-opacity-10 hover:border-opacity-100 transition duration-200"
                :class="[
                    i.id === currentId
                        ? 'bg-red bg-opacity-20 hover:bg-opacity-20'
                        : 'border-opacity-0',
                    episodeComingSoon(i) ? 'pointer-events-none' : '',
                ]"
                @click="$emit('itemClick', i)"
            >
                <div class="w-1/3 lg:w-1/5">
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
                            v-if="episodeComingSoon(i)"
                            class="absolute -top-1 -right-1 pointer-events-none"
                            >{{ t('episode.comingSoon') }}</Pill
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
                    class="w-2/3 ml-4 mt-2"
                    :class="episodeComingSoon(i) ? 'opacity-50' : ''"
                >
                    <h1 class="text-style-title-3 line-clamp-2">
                        <span v-if="viewEpisodeNumber && i.number"
                            >{{ i.number }}. </span
                        >{{ i.title }}
                    </h1>
                    <AgeRating :episode="i" />
                    <div
                        class="hidden lg:flex mt-1.5 text-style-body-2 opacity-70"
                    >
                        <div
                            class="pointer-events-none line-clamp-2 lg:line-clamp-3"
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
