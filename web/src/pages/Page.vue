<template>
    <div>
        <ItemSection
            v-for="section in query.data.value?.page?.sections.items"
            :section="section"
        >
        </ItemSection>
    </div>
</template>
<script lang="ts" setup>
import { useGetPageQuery } from "@/graph/generated"
import ItemSection from "@/components/sections/ItemSection.vue"
import { addError } from "@/utils/error"
import { useRoute } from "vue-router"

const route = useRoute()

const query = useGetPageQuery({
    variables: {
        code: route.params.pageId as string,
    },
})

query.then((r) => {
    if (query.error.value) {
        addError(query.error.value.message)
        return
    }
})
</script>
