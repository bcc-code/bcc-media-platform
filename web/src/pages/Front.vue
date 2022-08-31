<template>
    <div>
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

import { useGetPageQuery } from "@/graph/generated"
import { ref } from "vue"
import ItemSection, { Section } from "@/components/sections/ItemSection.vue"
import { Item } from "@/components/sections/SectionItem.vue"
import { addError } from "@/utils/error"

const query = useGetPageQuery({
    variables: {
        code: "frontpage",
    },
})

const title = ref(null as string | null)
const sections = ref([] as Section[])

query.then((r) => {
    if (query.error.value) {
        addError(query.error.value.message)
        return
    }
    const page = r.data.value?.page ?? null
    if (page) {
        title.value = page.title

        const getType = (type?: string) => {
            switch (type) {
                case "ShowItem":
                    return "show"
                case "SeasonItem":
                    return "season"
                case "EpisodeItem":
                    return "episode"
                case "PageItem":
                    return "page"
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
                    const type = getType(item.__typename)
                    if (!type) continue

                    switch (item.__typename) {
                        case "EpisodeItem":
                            items.push({
                                title: item.title,
                                type: "episode",
                                image: item.imageUrl ?? undefined,
                                number: item.episode.number ?? undefined,
                                season: item.episode.season?.number,
                                show: item.episode.season?.show.title,
                            })
                            break
                        case "SeasonItem":
                            items.push({
                                title: item.title,
                                type: "season",
                                image: item.imageUrl ?? undefined,
                                number: item.season.number,
                                show: item.season.show.title,
                            })
                            break
                        default:
                            const type = getType(item.__typename)
                            if (
                                type === "show" ||
                                type === "page" ||
                                type === "url"
                            ) {
                                items.push({
                                    type,
                                    title: item.title,
                                    image: item.imageUrl ?? undefined,
                                })
                            }
                    }
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
