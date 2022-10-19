<template>
    <div
        class="flex relative aspect-video bg-cover bg-center bg-no-repeat rounded rounded-2xl cursor-pointer"
        @click="onclick"
        :style="{
            'background-image':
                'linear-gradient(to top, rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0), rgba(0, 0, 0, 0)), url(\'' +
                item.image +
                '\')',
        }"
    >
        <div
            v-if="adminOn"
            class="absolute text-primary right-0 bg-black p-2 rounded cursor-pointer m-2"
            @click="open"
        >
            EDIT
        </div>
        <h1 class="text-lg p-2 text-primary font-semibold mt-auto">
            {{ item.title }}
        </h1>
    </div>
</template>
<script lang="ts" setup>
import { SearchQuery, useGetDefaultEpisodeIdQuery } from "@/graph/generated"
import { goToEpisode } from "@/utils/items";

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
        const { data, resume, then } = useGetDefaultEpisodeIdQuery({
            pause: true,
            variables: {

                showId: props.item.id,
            }
        })
        onclick = () => {
            then(() => {
                if (data.value?.show.defaultEpisode) {
                    goToEpisode(data.value.show.defaultEpisode.id)
                }
            })
            resume()
        }
        break;
    case "EpisodeSearchItem":
        onclick = () => {
            goToEpisode(props.item.id)
        }
}
</script>
