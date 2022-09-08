<template>
    <div class="mx-10">
        <ItemSection
            v-for="section in data?.page?.sections.items"
            :section="section"
        >
        </ItemSection>
    </div>
    <div v-if="error">{{error.message}}</div>
</template>
<script lang="ts" setup>
import { useGetPageQuery } from "@/graph/generated"
import ItemSection from "@/components/sections/ItemSection.vue"
import { getCurrentInstance, watch } from "vue";

const props = defineProps<{
    pageId: string
}>()

const { data, error } = useGetPageQuery({
    variables: {
        code: props.pageId,
    },
})
</script>
