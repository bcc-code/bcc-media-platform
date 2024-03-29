export const pageQuery = `query getPage(
    $code: String!
    $first: Int
    $offset: Int
    $sectionFirst: Int
    $sectionOffset: Int
) {
    page(code: $code) {
        id
        title
        code
        sections(first: $first, offset: $offset) {
            total
            offset
            first
            items {
                __typename
                id
                title
                ...ItemSection
                ... on WebSection {
                    title
                    url
                    height
                    aspectRatio
                    authentication
                }
                ... on MessageSection {
                    title
                    messages {
                        title
                        content
                        style {
                            text
                            background
                            border
                        }
                    }
                }
            }
        }
    }
}

fragment ItemSection on ItemSection {
    metadata {
        collectionId
        continueWatching
        useContext
        prependLiveElement
        secondaryTitles
    }

    items(first: $sectionFirst, offset: $sectionOffset) {
        total
        first
        offset
        items {
            ...SectionItem
        }
    }
    ... on DefaultSection {
        size
        items(first: $sectionFirst, offset: $sectionOffset) {
            items {
                description
            }
        }
    }
    ... on FeaturedSection {
        size
        items(first: $sectionFirst, offset: $sectionOffset) {
            items {
                description
            }
        }
    }
    ... on GridSection {
        gridSize: size
    }
    ... on PosterSection {
        size
    }
    ... on CardSection {
        cardSize: size
        items(first: $sectionFirst, offset: $sectionOffset) {
            items {
                item {
                    ... on StudyTopic {
                        ...StudyTopicSectionItem
                    }
                }
            }
        }
    }
}

fragment StudyTopicSectionItem on StudyTopic {
    id
    title
    description
    images {
        style
        url
    }
    lessonsProgress: progress {
        completed
        total
    }
}

fragment SectionItem on SectionItem {
    id
    image
    title
    sort
    item {
        __typename
        ... on Episode {
            id
            episodeNumber: number
            productionDate
            publishDate
            progress
            duration
            ageRating
            description
            season {
                id
                title
                number
                show {
                    id
                    type
                    title
                }
            }
        }
        ... on Season {
            id
            seasonNumber: number
            show {
                title
            }
            episodes(first: 1, dir: "desc") {
                items {
                    publishDate
                }
            }
        }
        ... on Show {
            id
            episodeCount
            seasonCount
            defaultEpisode {
                id
            }
            seasons(first: 1, dir: "desc") {
                items {
                    episodes(first: 1, dir: "desc") {
                        items {
                            publishDate
                        }
                    }
                }
            }
        }
        ... on Page {
            id
            code
        }
        ... on StudyTopic {
            id
        }
    }
}
`

export const setEpisodeProgressQuery = `
mutation ($id: ID!, $progress: Int!, $duration: Int!) {
    setEpisodeProgress(id: $id, progress: $progress, duration: $duration) {
        id
        progress
    }
}`