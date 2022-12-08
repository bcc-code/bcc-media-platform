import { GetSectionQuery, SectionItemFragment } from "@/graph/generated"
import router from "@/router"
import { analytics, Page } from "@/services/analytics"

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
    item: {
        index: number
        item: SectionItemFragment
    },
    section: {
        __typename: GetSectionQuery["section"]["__typename"]
        index: number
        id: string
        title?: string | null
        options?: {
            useContext: boolean
            collectionId: string
        } | null
    },
    pageCode: Page
) => {
    analytics.track("section_clicked", {
        sectionId: section.id,
        sectionName: section.title ?? "HIDDEN",
        sectionPosition: section.index,
        sectionType: section.__typename,
        elementId: item.item.id,
        elementName: item.item.title,
        elementType: item.item.item.__typename,
        elementPosition: item.index,
        pageCode,
    })

    switch (item.item.item?.__typename) {
        case "Episode":
            goToEpisode(item.item.id, section?.options)
            break
        case "Show":
            if (item.item.item.defaultEpisode)
                goToEpisode(item.item.item.defaultEpisode.id)
            break
        case "Page":
            goToPage(item.item.item.code)
            break
    }
}

export const itemDisabled = (item: SectionItemFragment) => {
    switch (item.item.__typename) {
        case "Episode":
            return new Date(item.item.publishDate).getTime() > new Date().getTime()
    }
    return false
}
