<template>
    <div>
        <div>
            {{ title }}
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

const query = useGetPageQuery({
    variables: {
        code: "frontpage",
    },
})

const title = ref(null as string | null)

query.then((r) => {
    if (query.error.value) {
        addError(query.error.value.message)
        return
    }
    const page = r.data.value?.page ?? null
    if (page) {
        title.value = page.title
    }
})
</script>
