import { SectionItemFragment } from "@/graph/generated"
import router from "@/router"

export const goToEpisode = (
    episodeId: string,
    options?: {
        useContext: boolean
        collectionId: string
    } | null
) => {
    if (options?.useContext) {
        router.push({
            name: "episode-collection-page",
            params: {
                episodeId,
                collection: options.collectionId,
            },
        })
    } else {
        router.push({
            name: "episode-page",
            params: {
                episodeId,
            },
        })
    }
}

export const goToPage = (code: string) => {
    router.push({
        name: "page",
        params: {
            pageId: code,
        },
    })
}

export const goToSectionItem = (
    item: SectionItemFragment,
    options?: {
        useContext: boolean
        collectionId: string
    } | null
) => {
    switch (item.item?.__typename) {
        case "Episode":
            goToEpisode(item.id, options)
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
