<template>
    <section>
        <div class="flex flex-col gap-8" v-if="data?.page?.sections.items.length">
            <Section
                v-for="section in data?.page?.sections.items"
                :section="section"
            >
            </Section>
        </div>
        <div v-if="fetching">FETCHING</div>
        <div v-else-if="!data?.page.sections.items.length">
            Uh oh. Missing content
        </div>
        <div v-if="error">{{ error.message }}</div>
    </section>
</template>
<script lang="ts" setup>
import { useGetPageQuery } from "@/graph/generated"
import Section from "@/components/sections/Section.vue"

const props = defineProps<{
    pageId: string
}>()

const { data, error, fetching } = useGetPageQuery({
    variables: {
        code: props.pageId,
    },
})
</script>
