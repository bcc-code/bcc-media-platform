<template>
    <div class="mx-10" v-if="data?.page?.sections.items.length">
        <ItemSection
            v-for="section in data?.page?.sections.items"
            :section="section"
        >
        </ItemSection>
    </div>
    <div v-else-if="!fetching">
        Uh oh. Missing content
    </div>
    <div v-if="error">{{error.message}}</div>
</template>
<script lang="ts" setup>
import { useGetPageQuery } from "@/graph/generated"
import ItemSection from "@/components/sections/ItemSection.vue"

const props = defineProps<{
    pageId: string
}>()

const { data, error, fetching } = useGetPageQuery({
    variables: {
        code: props.pageId,
    },
})
</script>
