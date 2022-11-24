<template>
    <section class="overflow-x-hidden">
        <transition name="slide-fade">
            <div
                class="px-4 lg:px-20 flex flex-col gap-8"
                v-if="page && page.sections.items.length"
            >
                <Section
                    v-for="(section, i) in page.sections.items"
                    :section="section"
                    :index="{ last: page.sections.total - 1, current: i }"
                    @load-more="appendItems(section)"
                >
                </Section>
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
    ItemSectionFragment,
    useGetPageQuery,
    useGetSectionQuery,
} from "@/graph/generated"
import Section from "@/components/sections/Section.vue"
import { computed, nextTick, onMounted, onUnmounted, ref } from "vue"
import NotFound from "../NotFound.vue"
import SkeletonSections from "./SkeletonSections.vue"

const props = defineProps<{
    pageId: string
}>()

const emit = defineEmits<{
    (e: "title", v: string): void
}>()

const { error, fetching, executeQuery } = useGetPageQuery({
    pause: true,
    variables: {
        code: computed(() => props.pageId),
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

onMounted(() => {
    document.body.onscroll = async () => {
        const bottomOfWindow =
            document.documentElement.scrollTop +
                (window.innerHeight + window.innerHeight / 2) >=
            document.documentElement.offsetHeight

        if (bottomOfWindow && !sectionQuery.fetching.value) {
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
})

onUnmounted(() => {
    document.body.onscroll = oldScroll
})

load()
</script>
