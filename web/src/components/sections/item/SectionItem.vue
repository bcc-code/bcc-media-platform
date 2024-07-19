<template>
    <div class="relative">
        <NewPill
            class="absolute -top-1 -right-1 pointer-events-none overflow-hidden"
            :item="i"
            v-if="!comingSoon(i)"
        ></NewPill>
        <Pill
            class="absolute -top-1 -right-1 pointer-events-none overflow-hidden z-50"
            v-else
            >{{ $t("episode.comingSoon") }}</Pill
        >
        <div
            class="flex flex-col mt-2 transition"
            :class="{
                'cursor-pointer': !comingSoon(i),
                'pointer-events-none': comingSoon(i),
                'opacity-50': clicked,
            }"
            @click="!comingSoon(i) ? click() : undefined"
        >
            <div
                class="relative mb-1 rounded-md w-full overflow-hidden hover:brightness-[1.15] transition group ease-out-expo"
                :class="aspect"
            >
                <div v-if="clicked" class="absolute w-full h-full flex">
                    <Loader variant="spinner" class="m-auto h-16 w-16"></Loader>
                </div>
                <Image
                    :src="i.image"
                    class="rounded-md group-hover:scale-[101%] transition-transform ease-out-expo duration-500"
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
                    v-if="comingSoon(i) && i.item.__typename === 'Episode'"
                    class="absolute flex top-0 h-full w-full bg-black bg-opacity-80"
                >
                    <div
                        class="mx-auto my-auto text-center items-center flex flex-col"
                    >
                        <LockClosedIcon
                            class="h-8 fill-gray my-auto"
                        ></LockClosedIcon>
                        <p class="text-style-button-1 text-slate-300">
                            {{ $t("episode.comingSoon") }}
                        </p>
                        <p class="text-style-button-1 text-slate-300">
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
import Loader from "@/components/Loader.vue"
import { SectionItemFragment } from "@/graph/generated"
import { comingSoon } from "@/utils/items"
import { LockClosedIcon } from "@heroicons/vue/24/solid"
import { computed, ref } from "vue"
import NewPill from "./NewPill.vue"
import Pill from "./Pill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"

const emit = defineEmits<{
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

const clicked = ref(false)

const click = () => {
    clicked.value = true
    emit("click")
}

const ratio = computed(() => {
    return {
        default: 16 / 9,
        poster: 240 / 357,
    }[props.type]
})

const aspect = computed(() => {
    return {
        default: "aspect-video",
        poster: "aspect-[240/357]",
    }[props.type]
})
</script>
