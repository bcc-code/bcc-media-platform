<template>
    <section class="overflow-x-hidden">
        <transition
            mode="out-in"
            enter-active-class="duration-300 ease-out"
            enter-from-class=" opacity-0"
            enter-to-class="opacity-100"
            leave-active-class="duration-200 ease-in"
            leave-from-class="opacity-100"
            leave-to-class=" opacity-0"
        >
            <div
                class="px-4 lg:px-20 flex flex-col gap-8 relative"
                v-if="page && page.sections.items.length"
            >
                <Section
                    v-for="(section, i) in page.sections.items"
                    :key="section.id"
                    :section="section"
                    :index="{ last: page.sections.total - 1, current: i }"
                    @load-more="appendItems(section)"
                    @click-item="(index) => clickItem(i, index)"
                    v-motion
                    :initial="{
                        opacity: 0.01,
                    }"
                    :enter="{
                        opacity: 1,
                        transition: {
                            duration: 1500,
                            ease: TransitionPresets.easeOutExpo,
                        },
                    }"
                    :delay="i < 10 ? i * 100 : 0"
                >
                </Section>
                <div
                    v-if="
                        page.sections.total >
                        page.sections.offset + page.sections.first
                    "
                    class="absolute bottom-0 left-0 w-full h-80 bg-gradient-to-t from-background to-transparent z-10 transition flex"
                >
                    <Loader v-if="fetching" class="mx-auto my-auto"></Loader>
                </div>
                <!-- <div v-else class="h-40"></div> -->
            </div>
            <div v-else-if="!fetching && !loading">
                <NotFound :title="$t('page.notFound')"></NotFound>
            </div>
            <div v-else-if="error">3{{ error.message }}</div>
            <div v-else class="flex w-full h-48 items-center justify-center">
                <Loader variant="spinner" />
            </div>
        </transition>
    </section>
</template>
<script lang="ts" setup>
import {
    GetPageQuery,
    GetSectionQuery,
    useGetPageQuery,
    useGetSectionQuery,
    useGetSectionsForPageQuery,
} from "@/graph/generated"
import Section from "@/components/sections/Section.vue"
import { computed, nextTick, onMounted, onUnmounted, ref } from "vue"
import NotFound from "../NotFound.vue"
import Loader from "../Loader.vue"
import SkeletonSections from "./SkeletonSections.vue"
import { goToSectionItem } from "@/utils/items"
import { TransitionPresets } from "@vueuse/core"

const props = defineProps<{
    pageId: string
}>()

const emit = defineEmits<{
    (e: "title", v: string): void
}>()

const pageFirst = ref(10)
const pageOffset = ref(0)

const { error, fetching, executeQuery } = useGetPageQuery({
    pause: true,
    variables: {
        code: computed(() => props.pageId),
        offset: 0,
        first: 10,
        sectionFirst: 10,
        sectionOffset: 0,
    },
})

const getSectionsQuery = useGetSectionsForPageQuery({
    pause: true,
    variables: {
        code: computed(() => props.pageId),
        offset: pageOffset,
        first: pageFirst,
        sectionFirst: 10,
        sectionOffset: 0,
    },
})

const page = ref(null as GetPageQuery["page"] | null)
const loading = ref(false)

const load = async () => {
    loading.value = true
    const result = await executeQuery()
    if (result.data.value?.page) {
        page.value = result.data.value.page
        if (page.value.title) {
            emit("title", page.value.title)
        }
    }
    loading.value = false
    await nextTick()
    loadMore()
}

const sectionId = ref("")
const first = ref(10)
const offset = ref(0)

const sectionQuery = useGetSectionQuery({
    pause: true,
    variables: {
        id: sectionId,
        first,
        offset,
    },
})

const appendItems = async (section: GetSectionQuery["section"]) => {
    switch (section.__typename) {
        case "DefaultGridSection":
        case "ListSection":
        case "IconGridSection":
        case "PosterGridSection":
        case "DefaultSection":
        case "FeaturedSection":
        case "PosterSection":
            if (
                section.items.total >
                section.items.offset + section.items.first
            ) {
                first.value = section.items.first
                offset.value = section.items.offset + first.value
                sectionId.value = section.id
                await nextTick()
                const result = await sectionQuery.executeQuery()
                if (
                    result.data.value?.section.__typename === section.__typename
                ) {
                    section.items.items.push(
                        ...result.data.value.section.items.items
                    )
                    section.items.first = result.data.value.section.items.first
                    section.items.offset =
                        result.data.value.section.items.offset
                }
            }
    }
}

const loadMore = async () => {
    const { scrollTop, offsetHeight } = document.documentElement
    const { innerHeight } = window

    const bottom = scrollTop + innerHeight * 2 >= offsetHeight

    // console.log(`ScrollTop: ${scrollTop}. \nOffsetHeight: ${offsetHeight}. \nInnerHeight: ${innerHeight}\nBottom: ${bottom} \n\n`)

    if (bottom) {
        const p = getSectionsQuery.data.value?.page ?? page.value
        if (!p) {
            return
        }

        if (p.sections.total > p.sections.offset + p.sections.first) {
            if (!fetching.value) {
                pageOffset.value = p.sections.offset + p.sections.first
                await nextTick()
                const r = await getSectionsQuery.executeQuery()
                if (r.data.value && page.value) {
                    page.value.sections.items.push(
                        ...r.data.value.page.sections.items
                    )
                    page.value.sections.offset =
                        r.data.value.page.sections.offset
                    page.value.sections.first = r.data.value.page.sections.first
                }
            }
        } else if (!sectionQuery.fetching.value) {
            const sections = p.sections.items
            const lastSection = sections[sections.length - 1]
            if (lastSection) {
                switch (lastSection.__typename) {
                    case "DefaultGridSection":
                    case "ListSection":
                    case "IconGridSection":
                    case "PosterGridSection":
                        await appendItems(lastSection)
                }
            }
        }
    }
}

const clickItem = (sectionIndex: number, itemIndex: number) => {
    if (!page.value) {
        return
    }

    for (let i = 0; i < page.value.sections.items.length; i++) {
        if (sectionIndex === i) {
            const section = page.value.sections.items[i]
            switch (section.__typename) {
                case "DefaultGridSection":
                case "DefaultSection":
                case "FeaturedSection":
                case "IconGridSection":
                case "IconSection":
                case "LabelSection":
                case "ListSection":
                case "CardListSection":
                case "CardSection":
                case "PosterGridSection":
                case "PosterSection":
                    for (let i = 0; i < section.items.items.length; i++) {
                        if (i === itemIndex) {
                            // TODO: refactor to pass the item. This can cause bugs when the section filters out certain types, like CardSection does
                            goToSectionItem(
                                {
                                    index: i,
                                    item: section.items.items[i],
                                },
                                {
                                    ...section,
                                    index: sectionIndex,
                                    options: {
                                        useContext:
                                            section.metadata?.useContext ===
                                            true,
                                        collectionId:
                                            section.metadata?.collectionId ??
                                            "",
                                    },
                                },
                                page.value.code
                            )
                        }
                    }
            }
        }
    }
}

const oldScroll = document.body.onscroll
const oldTouchMove = document.body.ontouchmove

onMounted(() => {
    document.body.onscroll = loadMore
    document.body.ontouchmove = loadMore
})

onUnmounted(() => {
    document.body.onscroll = oldScroll
    document.body.ontouchmove = oldTouchMove
})

load()
</script>
