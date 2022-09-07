<template>
    <div class="m-10">
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

const { data, error } = useGetPageQuery({
    variables: {
        code: "frontpage",
    },
})
</script>
