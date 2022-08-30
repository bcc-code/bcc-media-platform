<template>
    <div>
        <Card>Main</Card>
        <div>
            {{ title }}
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
import ItemSection, { Section } from "@/components/sections/ItemSection.vue";
import { Item } from "@/components/sections/SectionItem.vue";

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

        const getType = (type?: string) => {
            switch (type) {
                case "ShowItem":
                    return "show";
                case "SeasonItem":
                    return "season";
                case "EpisodeItem":
                    return "episode";
                case "PageItem":
                    return "page";
                case "URLItem":
                    return "url"
                default:
                    return null
            }
        }

        for (const section of page.sections.items) {
            if (section.__typename === "ItemSection") {

                const items: Item[] = []
                for (const item of section.items.items) {
                    let header = null as string | null
                    let header2 = null as string | null
                    switch (item.__typename) {
                        case "EpisodeItem":
                            if (item.episode.season && item.episode.number) {
                                header = item.episode.season.show.title
                                header2 = "S" + item.episode.season.number + ":E" + item.episode.number
                            }
                            break;
                        case "SeasonItem":
                            header = item.season.show.title
                            header2 = "S" + item.season.number
                            break;
                    }

                    items.push({
                        title: item.title,
                        type: getType(item.__typename),
                        header: header ?? undefined,
                        header2: header2 ?? undefined,
                        image: item.imageUrl ?? undefined,
                    })
                }

                sections.value.push({
                    title: section.title,
                    items,
                })
            }
        }
    }
})

</script>
