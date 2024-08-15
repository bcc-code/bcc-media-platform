import client from '@/graph/client'
import {
    CollectionItemThumbnailFragment,
    GetDefaultEpisodeForTopicDocument,
    GetDefaultEpisodeForTopicQuery,
    GetDefaultEpisodeForTopicQueryVariables,
    GetPlaylistEpisodeDocument,
    GetPlaylistEpisodeQuery,
    GetPlaylistEpisodeQueryVariables,
    GetSectionQuery,
    Link,
    SectionItemFragment,
} from '@/graph/generated'
import router from '@/router'
import { analytics, Page } from '@/services/analytics'

export const goToEpisode = (
    episodeId: string,
    options?: {
        useContext: boolean
        collectionId: string
    } | null
) => {
    if (options?.useContext) {
        router.push({
            name: 'episode-collection-page',
            params: {
                episodeId,
                collection: options.collectionId,
            },
        })
    } else {
        router.push({
            name: 'episode-page',
            params: {
                episodeId,
            },
        })
    }
}

export const goToLink = async (item: Partial<Link>) => {
    if (!item.url) return
    window.location.assign(item.url)
}
export const goToPlaylist = async (playlistId: string) => {
    const result = await client
        .query<
            GetPlaylistEpisodeQuery,
            GetPlaylistEpisodeQueryVariables
        >(GetPlaylistEpisodeDocument, { id: playlistId })
        .toPromise()
    for (const i of result.data?.playlist.items.items ?? []) {
        if (i.__typename === 'Episode') {
            router.push({
                name: 'playlist-episode',
                params: {
                    playlistId,
                    episodeId: i.id,
                },
            })
            return
        }
    }
}

export const goToPage = (code: string) => {
    router.push({
        name: 'page',
        params: {
            pageId: code,
        },
    })
}

export const goToStudyTopic = async (id: string) => {
    // TODO: nothing is as permanent as a temporary solution lol
    // although things can be improved :)
    const result = await client
        .query<
            GetDefaultEpisodeForTopicQuery,
            GetDefaultEpisodeForTopicQueryVariables
        >(GetDefaultEpisodeForTopicDocument, { id: id })
        .toPromise()
    const episodeId = result.data?.studyTopic.defaultLesson.defaultEpisode?.id
    if (!episodeId) {
        throw Error(`Failed finding an episode to navigate to for topic ${id}`)
    }

    router.push({
        name: 'episode-page',
        params: {
            episodeId,
        },
    })
}

export const goToShow = async (id: string) => {
    // TODO: nothing is as permanent as a temporary solution lol
    // although things can be improved :)
    router.push({
        name: 'show',
        params: { showId: id },
    })
}

export const goToSectionItem = async (
    item: {
        index: number
        item: SectionItemFragment
    },
    section: {
        __typename: GetSectionQuery['section']['__typename']
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
    analytics.track('section_clicked', {
        sectionId: section.id,
        sectionName: section.title ?? 'HIDDEN',
        sectionPosition: section.index,
        sectionType: section.__typename,
        elementId: item.item.id,
        elementName: item.item.title,
        elementType: item.item.item.__typename,
        elementPosition: item.index,
        pageCode,
    })

    switch (item.item.item?.__typename) {
        case 'Episode':
            goToEpisode(item.item.id, section?.options)
            break
        case 'Show':
            await goToShow(item.item.item.id)
            break
        case 'Page':
            goToPage(item.item.item.code)
            break
        case 'StudyTopic':
            await goToStudyTopic(item.item.item.id)
            break
        case 'Playlist':
            await goToPlaylist(item.item.item.id)
            break
        case 'Link':
            await goToLink(item.item.item)
    }
}

export const comingSoon = (item: CollectionItemThumbnailFragment) => {
    switch (item.__typename) {
        case 'Episode':
            return (
                item.locked &&
                new Date(item.publishDate).getTime() > new Date().getTime()
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

export function isCollectionItem(
    item: unknown
): item is CollectionItemThumbnailFragment {
    return true
}

export function isNewEpisode(episode: {
    publishDate?: string | null | undefined
    locked?: boolean | null | undefined
}) {
    if (episode.locked) return false
    if (episode.publishDate == null) return false
    const date = new Date()
    date.setDate(date.getDate() - 7)
    return new Date(episode.publishDate).getTime() > date.getTime()
}
