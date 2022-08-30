<template>
    <div>
        <Card>Main</Card>
        <div>
            {{title}}
        </div>
        <div v-if="sections">
            <div v-for="section in sections">
                {{section.title}}
                <p v-for="i in section.items">
                    {{i.type}} | {{i.title}}
                </p>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import Card from "@/components/Card.vue"

import { useGetPageQuery } from "@/graph/generated";
import { ref } from "vue";

const result = useGetPageQuery({
    variables: {
        code: "frontpage",
    }
})

type Section = {
    title: string;
    items: {
        type: string;
        title: string;
    }[]
}

const title = ref(null as string | null)
const sections = ref(null as Partial<Section>[] | null)

result.then((r) => {
    const page = r.data.value?.page ?? null
    if (page) {
        title.value = page.title;

        const s = [] as Section[]

        for (const section of page.sections.items) {
            s.push({
                title: section.title,
                items: section.items?.items.map(i => ({
                    type: i.__typename ?? "",
                    title: i.title,
                })) ?? []
            })
        }

        sections.value = s
    }
})

</script>
