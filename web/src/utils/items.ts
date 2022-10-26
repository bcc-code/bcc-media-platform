import { SectionItemFragment } from "@/graph/generated"
import router from "@/router"

export const goToEpisode = (episodeId: string) => {
    router.push({
        name: "episode-page",
        params: {
            episodeId,
        },
    })
}

export const goToPage = (code: string) => {
    router.push({
        name: "page",
        params: {
            pageId: code,
        }
    })
}

export const goToSectionItem = (item: SectionItemFragment) => {
    switch (item.item?.__typename) {
        case "Episode":
            goToEpisode(item.id)
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
