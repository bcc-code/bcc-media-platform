<template>
    <div class="relative">
        <NewPill class="absolute top-0 -right-1" :item="i"></NewPill>
        <div
            class="flex flex-col mt-2"
            :class="{
                'cursor-pointer': !itemDisabled(i),
                'pointer-events-none': itemDisabled(i),
            }"
            @click="!itemDisabled(i) ? $emit('click') : undefined"
        >
            <div
                class="relative mb-1 rounded-md w-full overflow-hidden hover:opacity-90 transition"
                :class="aspect"
            >
                <Image
                    :src="i.image"
                    class="rounded-md"
                    loading="lazy"
                    size-source="height"
                    :ratio="ratio"
                />
                <ProgressBar
                    class="absolute bottom-0 w-full"
                    v-if="i.item?.__typename === 'Episode'"
                    :item="i.item"
                />
                <div
                    v-if="itemDisabled(i) && i.item.__typename === 'Episode'"
                    class="absolute flex top-0 h-full w-full bg-black bg-opacity-80"
                >
                    <div
                        class="mx-auto my-auto text-center items-center flex flex-col"
                    >
                        <LockClosedIcon
                            class="h-8 fill-gray my-auto"
                        ></LockClosedIcon>
                        <p class="font-semibold text-sm text-slate-300">
                            {{ $t("episode.comingSoon") }}
                        </p>
                        <p class="text-base font-semibold text-slate-300">
                            {{ new Date(i.item.publishDate).toLocaleString() }}
                        </p>
                    </div>
                </div>
            </div>
            <SectionItemTitle
                :secondary-titles="secondaryTitles"
                :i="i"
            ></SectionItemTitle>
        </div>
    </div>
</template>
<script lang="ts" setup>
import ProgressBar from "@/components/episodes/ProgressBar.vue"
import Image from "@/components/Image.vue"
import { SectionItemFragment } from "@/graph/generated"
import { itemDisabled } from "@/utils/items"
import { LockClosedIcon } from "@heroicons/vue/24/solid"
import { computed } from "vue"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"

defineEmits<{
    (e: "click"): void
}>()

const props = withDefaults(
    defineProps<{
        i: SectionItemFragment
        secondaryTitles?: boolean
        type: "default" | "poster"
    }>(),
    { secondaryTitles: false }
)

const ratio = computed(() => {
    return {
        default: 16 / 9,
        poster: 240 / 357,
    }[props.type]
})

const aspect = computed(() => {
    return {
        default: "aspect-video",
        poster: "aspect-[240/357]"
    }[props.type]
})
</script>
