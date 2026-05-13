<script lang="ts" setup>
import ProgressBar from '@/components/episodes/ProgressBar.vue'
import Image from '@/components/Image.vue'
import Loader from '@/components/Loader.vue'
import Pill from '@/components/Pill.vue'
import type { CollectionItemThumbnailFragment } from '@/graph/generated'
import { comingSoon, interceptSpaLinkClick } from '@/utils/items'
import { LockClosedIcon } from '@heroicons/vue/24/solid'
import { computed, ref } from 'vue'
import CollectionItemThumbnailTitle from './CollectionItemThumbnailTitle.vue'
import NewPill from './NewPill.vue'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const emit = defineEmits<{
    // `isModified` is true when the user used cmd/ctrl/shift/middle-click — in
    // that case the browser handles the navigation via the real <a href>, so
    // listeners should track analytics only and skip SPA navigation.
    click: [isModified: boolean]
}>()

const props = withDefaults(
    defineProps<{
        item: CollectionItemThumbnailFragment
        title: string
        image: string | null | undefined
        href?: string | null
        secondaryTitles?: boolean
        type?: 'default' | 'poster'
    }>(),
    {
        type: 'default',
        secondaryTitles: false,
        href: null,
    }
)

const clicked = ref(false)

const click = () => {
    clicked.value = true
    emit('click', false)
}

// eslint-disable-next-line no-undef
const onLinkClick = (event: MouseEvent) =>
    interceptSpaLinkClick(event, true, (modified) => {
        emit('click', modified)
        if (!modified) clicked.value = true
    })

const ratio = computed(() => {
    return {
        default: 16 / 9,
        poster: 240 / 357,
    }[props.type]
})

const aspect = computed(() => {
    return {
        default: 'aspect-video',
        poster: 'aspect-[240/357]',
    }[props.type]
})
</script>

<template>
    <article class="relative">
        <NewPill
            v-if="!comingSoon(item)"
            class="absolute -top-1 -right-1 pointer-events-none overflow-hidden"
            :item="item"
        />
        <Pill
            v-else-if="comingSoon(item)"
            class="absolute -top-1 -right-1 pointer-events-none overflow-hidden z-50"
        >
            {{ t('episode.comingSoon') }}
        </Pill>
        <component
            :is="href && !comingSoon(item) ? 'a' : 'button'"
            v-if="item"
            :href="href && !comingSoon(item) ? href : undefined"
            class="flex text-start h-full w-full flex-col mt-2 transition ease-out-expo focus-visible:ring-4 focus-visible:ring-white/75 rounded-md"
            :class="{
                'cursor-pointer': !comingSoon(item),
                'pointer-events-none': comingSoon(item),
                'opacity-50': clicked,
            }"
            @click="
                comingSoon(item)
                    ? undefined
                    : href
                      ? onLinkClick($event)
                      : click()
            "
        >
            <div
                class="relative mb-1 rounded-md w-full overflow-hidden hover:brightness-[1.15] transition group ease-out-expo"
                :class="aspect"
            >
                <div v-if="clicked" class="absolute w-full h-full flex">
                    <Loader variant="spinner" class="m-auto h-16 w-16" />
                </div>
                <Image
                    :src="image"
                    class="rounded-md group-hover:scale-[101%] transition-transform ease-out-expo duration-500"
                    loading="lazy"
                    size-source="height"
                    :ratio="ratio"
                />
                <ProgressBar
                    v-if="item.__typename === 'Episode'"
                    class="absolute bottom-0 w-full"
                    :item="item"
                />
                <div
                    v-if="comingSoon(item) && item.__typename === 'Episode'"
                    class="absolute flex top-0 h-full w-full bg-black bg-opacity-80"
                >
                    <div
                        class="mx-auto my-auto text-center items-center flex flex-col"
                    >
                        <LockClosedIcon class="h-8 fill-gray my-auto" />
                        <p class="text-style-button-1 text-slate-300">
                            {{ t('episode.comingSoon') }}
                        </p>
                        <p class="text-style-button-1 text-slate-300">
                            {{ new Date(item.publishDate).toLocaleString() }}
                        </p>
                    </div>
                </div>
            </div>
            <CollectionItemThumbnailTitle
                :item="item"
                :title="title"
                :secondary-titles="secondaryTitles"
            />
        </component>
    </article>
</template>
