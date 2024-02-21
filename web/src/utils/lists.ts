import {
    GetSeasonOnEpisodePageQuery,
    SectionItemFragment,
} from "@/graph/generated"

export type ListItem = {
    id: string
    type: SectionItemFragment["item"]["__typename"]
    title: string
    image?: string | null
    progress?: number | null
    number?: number | null
    duration?: number | null
    ageRating?: string | null
    description?: string | null
    publishDate?: string | null
}

export const toListItem = (fragment: SectionItemFragment): ListItem => {
    const item: ListItem = {
        type: fragment.item.__typename,
        id: fragment.id,
        title: fragment.title,
        image: fragment.image,
    }
    switch (fragment.item.__typename) {
        case "Episode":
            item.number = fragment.item.episodeNumber
            item.progress = fragment.item.progress
            item.ageRating = fragment.item.ageRating
            item.duration = fragment.item.duration
            item.description = fragment.item.description
            item.publishDate = fragment.item.publishDate
    }
    return item
}

export const toListItems = (fragments: SectionItemFragment[]): ListItem[] => {
    return fragments.map((i) => toListItem(i))
}

export const episodesToListItems = (
    episodes: GetSeasonOnEpisodePageQuery["season"]["episodes"]["items"]
): ListItem[] => {
    const items = episodes.map(
        (i) =>
        ({
            id: i.id,
            uuid: i.uuid,
            type: "Episode",
            title: i.title,
            image: i.image,
            ageRating: i.ageRating,
            duration: i.duration,
            number: i.number,
            progress: i.progress,
            description: i.description,
            publishDate: i.publishDate,
        } as ListItem)
    )

    return items
}
