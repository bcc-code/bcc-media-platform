import { SectionItemFragment } from "@/graph/generated"
import router from "@/router"

export const goToEpisode = (episodeId: string, collection?: string) => {
    router.push({
        name: "episode-page",
        params: {
            episodeId,
        },
        query: router.currentRoute.value.query.collection ? router.currentRoute.value.query : (collection ? {collection} : undefined),
    })
}

export const goToPage = (code: string) => {
    router.push({
        name: "page",
        params: {
            pageId: code,
        },
    })
}

export const goToSectionItem = (item: SectionItemFragment, collection?: string) => {
    switch (item.item?.__typename) {
        case "Episode":
            goToEpisode(item.id, collection)
            break
        case "Show":
            if (item.item.defaultEpisode)
                goToEpisode(item.item.defaultEpisode.id)
            break
        case "Page":
            goToPage(item.item.code)
            break
    }
}
