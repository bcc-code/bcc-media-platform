<template>
    <section class="overflow-x-hidden">
        <transition name="slide-fade">
            <div
                class="px-4 lg:px-20 flex flex-col gap-8 relative"
                v-if="page && page.sections.items.length"
            >
                <TransitionGroup name="slide-fade">
                    <Section
                        v-for="(section, i) in page.sections.items"
                        :key="section.id"
                        :section="section"
                        :index="{ last: page.sections.total - 1, current: i }"
                        @load-more="appendItems(section)"
                    >
                    </Section>
                </TransitionGroup>
                <div
                    v-if="
                        page.sections.total >
                        page.sections.offset + page.sections.first
                    "
                    class="absolute bottom-0 left-0 w-full h-80 bg-gradient-to-t from-background to-transparent z-10 transition flex"
                >
                    <Loader v-if="fetching" class="mx-auto my-auto"></Loader>
                </div>
            </div>
            <div v-else-if="!fetching">
                <NotFound :title="$t('page.notFound')"></NotFound>
            </div>
            <div v-else-if="error">{{ error.message }}</div>
            <SkeletonSections class="px-4 lg:px-20" v-else></SkeletonSections>
        </transition>
    </section>
</template>
<script lang="ts" setup>
import {
    GetPageQuery,
    GetSectionQuery,
    useGetPageQuery,
    useGetSectionQuery,
} from "@/graph/generated"
import Section from "@/components/sections/Section.vue"
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from "vue"
import NotFound from "../NotFound.vue"
import SkeletonSections from "./SkeletonSections.vue"
import Loader from "../Loader.vue"

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
        offset: pageOffset,
        first: pageFirst,
    },
})

const page = ref(null as NonNullable<GetPageQuery["page"]> | null)

const load = async () => {
    const result = await executeQuery()
    if (result.data.value?.page) {
        page.value = result.data.value.page
        if (page.value.title) {
            emit("title", page.value.title)
        }
    }
    await nextTick()
    loadMore()
}

const sectionId = ref("")
const first = ref(20)
const offset = ref(0)

const sectionQuery = useGetSectionQuery({
    pause: true,
    variables: {
        id: sectionId,
        first,
        offset,
    },
})

const oldScroll = document.body.onscroll

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
    const bottomOfWindow =
        document.documentElement.scrollTop +
            (window.innerHeight + window.innerHeight / 2) >=
        document.documentElement.offsetHeight

    if (bottomOfWindow) {
        console.log("is bottom")
        if (
            page.value &&
            page.value.sections.total >
                page.value.sections.offset + page.value.sections.first
        ) {
            pageOffset.value =
                page.value.sections.offset + page.value.sections.first
            await nextTick()
            const r = await executeQuery()
            if (r.data.value) {
                page.value.sections.items.push(
                    ...r.data.value.page.sections.items
                )
                page.value.sections.offset = r.data.value.page.sections.offset
                page.value.sections.first = r.data.value.page.sections.first
            }
        } else if (!sectionQuery.fetching.value) {
            const sections = page.value?.sections.items
            if (sections) {
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
}

onMounted(() => {
    document.body.onscroll = loadMore
})

onUnmounted(() => {
    document.body.onscroll = oldScroll
})

load()
</script>
