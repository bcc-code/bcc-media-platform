<template>
    <div class="p-10">
        <ItemSection
            v-for="section in query.data.value?.page?.sections.items"
            :section="section"
        >
        </ItemSection>
    </div>
</template>
<script lang="ts" setup>
import { useGetPageQuery } from "@/graph/generated"
import { ref } from "vue"
import ItemSection from "@/components/sections/ItemSection.vue"
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
