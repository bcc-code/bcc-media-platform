<template>
    <div>
        <div>
            {{ query.data.value?.page?.title }}
        </div>
        <div>
            <ItemSectionComponent
                v-for="section in query.data.value?.page?.sections.items"
                :section="section"
            >
            </ItemSectionComponent>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { GetPageQuery, ItemSection, useGetPageQuery } from "@/graph/generated"
import { ref } from "vue"
import ItemSectionComponent from "@/components/sections/ItemSection.vue"
import { addError } from "@/utils/error"
import { useRoute } from "vue-router";

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
