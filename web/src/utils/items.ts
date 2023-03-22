import {
    GetSectionQuery,
    SectionItemFragment,
    GetStudyTopicLessonStatusesQuery,
    GetStudyTopicLessonStatusesDocument,
    GetStudyTopicLessonStatusesQueryVariables,
} from "@/graph/generated"
import router from "@/router"
import { analytics, Page } from "@/services/analytics"
import { createRequest } from "@urql/vue"
import client from "@/graph/client"

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

export const goToStudyTopic = async (id: string) => {
    // TODO: nothing is as permanent as a temporary solution lol
    const result = await client
        .query<
            GetStudyTopicLessonStatusesQuery,
            GetStudyTopicLessonStatusesQueryVariables
        >(GetStudyTopicLessonStatusesDocument, { first: 100, id: id })
        .toPromise()
    const uncompletedLessonWithEpisode =
        result.data?.studyTopic.lessons.items.find(
            (el) =>
                (console.log(el.episodes.items) as any) ||
                (!el.completed && el.episodes.items[0]?.locked == false)
        )
    var episodeId = uncompletedLessonWithEpisode?.episodes.items[0]?.id
    console.log(uncompletedLessonWithEpisode)
    console.log(episodeId)
    episodeId ??=
        result.data?.studyTopic.lessons.items[0]?.episodes.items[0]?.id
    if (episodeId == null) {
        throw Error(`Failed finding an episode to navigate to for topic ${id}`)
    }

    router.push({
        name: "episode-page",
        params: {
            episodeId,
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
            goToEpisode(item.item.item.defaultEpisode.id)
            break
        case "Page":
            goToPage(item.item.item.code)
            break
        case "StudyTopic":
            goToStudyTopic(item.item.item.id)
            break
    }
}

export const comingSoon = (item: SectionItemFragment) => {
    switch (item.item.__typename) {
        case "Episode":
            return (
                item.item.locked && new Date(item.item.publishDate).getTime() > new Date().getTime()
            )
    }
    return false
}

export const episodeComingSoon = (episode: {
    publishDate?: string | null | undefined
}) => {
    return (
        episode.publishDate != null &&
        new Date(episode.publishDate).getTime() > new Date().getTime()
    )
}
