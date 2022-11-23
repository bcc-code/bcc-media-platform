<template>
    <section class="overflow-x-hidden">
        <transition name="slide-fade">
            <div
                class="px-4 flex flex-col gap-8"
                v-if="data?.page.sections.items.length"
            >
                <Section
                    v-for="(section, i) in data?.page?.sections.items"
                    :section="section"
                    :index="{ last: data.page.sections.total - 1, current: i }"
                >
                </Section>
            </div>
            <div v-else-if="!fetching">
                <NotFound :title="$t('page.notFound')"></NotFound>
            </div>
            <div v-else-if="error">{{ error.message }}</div>
            <SkeletonSections v-else></SkeletonSections>
        </transition>
    </section>
</template>
<script lang="ts" setup>
import { useGetPageQuery } from "@/graph/generated"
import Section from "@/components/sections/Section.vue"
import { onMounted, watch } from "vue"
import NotFound from "../NotFound.vue"
import SkeletonSections from "./SkeletonSections.vue"

const props = defineProps<{
    pageId: string
}>()

const emit = defineEmits<{
    (e: "title", v: string): void
}>()

const { data, error, fetching } = useGetPageQuery({
    variables: {
        code: props.pageId,
    },
})

watch(
    () => data.value?.page.title,
    () => {
        const title = data.value?.page.title
        if (title) {
            emit("title", title)
        }
    }
)

onMounted(() => {
    const title = data.value?.page.title
    if (title) {
        emit("title", title)
    }
})
</script>
