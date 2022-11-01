<template>
    <div
        class="relative aspect-video rounded rounded-xl overflow-hidden cursor-pointer"
        @click="onclick"
    >
        <img
            class="absolute"
            :src="item.image + '?w=800&h=450&fit=crop&crop=faces'"
        />
        <div
            class="absolute h-full relative bg-gradient-to-t from-black via-transparent to-transparent"
        >
            <div
                v-if="adminOn"
                class="absolute text-primary right-0 bg-black p-2 rounded cursor-pointer m-2"
                @click="open"
            >
                EDIT
            </div>
            <h1
                class="absolute bottom-0 text-lg p-2 text-primary font-semibold mt-auto"
            >
                {{ item.title }}
            </h1>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { SearchQuery, useGetDefaultEpisodeIdQuery } from "@/graph/generated"
import { goToEpisode } from "@/utils/items"

const props = defineProps<{
    item: SearchQuery["search"]["result"][0]
}>()

const adminOn = localStorage.getItem("admin") === "true"

const open = () => {
    let collection = ""
    switch (props.item.__typename) {
        case "EpisodeSearchItem":
            collection = "episodes"
            break
        case "SeasonSearchItem":
            collection = "seasons"
            break
        case "ShowSearchItem":
            collection = "shows"
            break
    }

    window.open(
        "https://admin.brunstad.tv/admin/content/" +
            collection +
            "/" +
            props.item.id
    )
}

let onclick = () => {}

switch (props.item.__typename) {
    case "ShowSearchItem":
        const { data, executeQuery } = useGetDefaultEpisodeIdQuery({
            pause: true,
            variables: {
                showId: props.item.id,
            },
        })

        onclick = () => {
            executeQuery().then(() => {
                if (data.value?.show.defaultEpisode) {
                    goToEpisode(data.value.show.defaultEpisode.id)
                }
            })
        }
        break
    case "EpisodeSearchItem":
        onclick = () => {
            goToEpisode(props.item.id)
        }
}
</script>
