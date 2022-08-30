<template>
    <div>
        <Card>Main</Card>
        <div>
            {{title}}
        </div>
        <div v-if="sections">
            <ItemSection v-for="section in sections" :section="section">

            </ItemSection>
        </div>
    </div>
</template>
<script lang="ts" setup>
import Card from "@/components/Card.vue"

import { useGetPageQuery } from "@/graph/generated";
import { ref } from "vue";
import ItemSection, { Section } from "@/components/ItemSection.vue";

const result = useGetPageQuery({
    variables: {
        code: "frontpage",
    }
})

const title = ref(null as string | null)
const sections = ref([] as Section[])

result.then((r) => {
    const page = r.data.value?.page ?? null
    if (page) {
        title.value = page.title;

        for (const section of page.sections.items) {
            if (section.__typename === "ItemSection") {
                sections.value.push({
                    title: section.title,
                    items: section.items.items.map(i => ({
                        title: i.title,
                        image: i.imageUrl ?? undefined,
                    }))
                })
            }
        }
    }
})

</script>
