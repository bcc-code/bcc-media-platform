<template>
    <section>
        <div class="w-full lg:w-1/2">
            <TransitionGroup name="slide-fade" mode="out-in">
                <div
                    v-for="i in items.filter((i) => i.type === 'Episode')"
                    class="flex p-2 gap-2 cursor-pointer border-l-4 border-red hover:bg-red hover:bg-opacity-10 hover:border-opacity-100 transition duration-200"
                    :class="[
                        i.id === currentId
                            ? 'bg-red bg-opacity-20 hover:bg-opacity-20'
                            : 'border-opacity-0',
                    ]"
                    @click="$emit('itemClick', i)"
                    :key="i.id"
                >
                    <WithProgressBar
                        v-if="i.duration"
                        class="w-1/3 aspect-video text-xs rounded-lg overflow-hidden"
                        :item="{
                            duration: i.duration,
                            progress: i.progress,
                            id: i.id,
                        }"
                    >
                        <Image
                            v-if="i.image"
                            :src="i.image"
                            size-source="width"
                            :ratio="9 / 16"
                        />
                    </WithProgressBar>
                    <div class="w-2/3 ml-4">
                        <h1 class="text-sm font-light lg:text-lg line-clamp-2">
                            <span v-if="viewEpisodeNumber && i.number"
                                >{{ i.number }}. </span
                            >{{ i.title }}
                        </h1>
                        <AgeRating v-if="i.ageRating">{{
                            i.ageRating
                        }}</AgeRating>
                        <div
                            class="hidden lg:flex mt-1.5 line-clamp-2 text-sm opacity-70"
                        >
                            {{ i.description }}
                        </div>
                    </div>
                </div>
            </TransitionGroup>
        </div>
    </section>
</template>
<script lang="ts" setup>
import Image from "../Image.vue"
import WithProgressBar from "@/components/episodes/WithProgressBar.vue"
import AgeRating from "../episodes/AgeRating.vue"
import { ListItem } from "@/utils/lists"

defineProps<{
    items: ListItem[]
    currentId: string
    viewEpisodeNumber?: boolean
}>()

defineEmits<{
    (e: "itemClick", i: ListItem): void
}>()
</script>
