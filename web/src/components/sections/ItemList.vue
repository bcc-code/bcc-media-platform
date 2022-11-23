<template>
    <section>
        <div class="grid grid-cols-2 lg:grid-cols-4 mt-2">
            <div
                v-for="i in items.filter(
                    (i) => i.item.__typename === 'Episode'
                )"
                class="relative mb-5"
            >
                <NewPill class="absolute top-0 -right-1" :item="i"></NewPill>
                <div
                    class="flex flex-col cursor-pointer hover:opacity-90 transition rounded-lg p-2"
                    :class="[currentId === i.id ? 'bg-slate-800' : '']"
                    @click="$emit('setCurrent', i)"
                >
                    <div
                        class="relative mb-1 rounded-md w-full aspect-video overflow-hidden"
                    >
                        <Image
                            :src="i.image"
                            size-source="width"
                            :ratio="9 / 16"
                        />
                        <ProgressBar
                            class="absolute bottom-0 w-full"
                            v-if="i?.item.__typename === 'Episode'"
                            :item="i.item"
                        />
                    </div>
                    <SectionItemTitle :i="i"></SectionItemTitle>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { SectionItemFragment } from "@/graph/generated"
import ProgressBar from "../episodes/ProgressBar.vue"
import Image from "../Image.vue"
import NewPill from "./item/NewPill.vue"
import SectionItemTitle from "./item/SectionItemTitle.vue"

defineProps<{
    items: SectionItemFragment[]
    currentId: string
}>()

defineEmits<{
    (e: "setCurrent", i: SectionItemFragment): void
}>()
</script>
