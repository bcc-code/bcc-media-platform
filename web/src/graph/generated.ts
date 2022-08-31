import gql from "graphql-tag"
import * as Urql from "@urql/vue"
export type Maybe<T> = T | null
export type InputMaybe<T> = Maybe<T>
export type Exact<T extends { [key: string]: unknown }> = {
    [K in keyof T]: T[K]
}
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & {
    [SubKey in K]?: Maybe<T[SubKey]>
}
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & {
    [SubKey in K]: Maybe<T[SubKey]>
}
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
    ID: string
    String: string
    Boolean: boolean
    Int: number
    Float: number
    Cursor: any
    Date: any
}

export type AppConfig = {
    __typename?: "AppConfig"
    minVersion: Scalars["String"]
}

export type Calendar = {
    __typename?: "Calendar"
    day?: Maybe<CalendarDay>
    period?: Maybe<CalendarPeriod>
}

export type CalendarDayArgs = {
    day: Scalars["Date"]
}

export type CalendarPeriodArgs = {
    from: Scalars["Date"]
    to: Scalars["Date"]
}

export type CalendarDay = {
    __typename?: "CalendarDay"
    entries: Array<CalendarEntry>
    events: Array<Event>
}

export type CalendarEntry = {
    description: Scalars["String"]
    end: Scalars["Date"]
    event?: Maybe<Event>
    id: Scalars["ID"]
    start: Scalars["Date"]
    title: Scalars["String"]
}

export type CalendarPeriod = {
    __typename?: "CalendarPeriod"
    activeDays: Array<Scalars["Date"]>
    events: Array<Event>
}

export type Chapter = {
    __typename?: "Chapter"
    id: Scalars["ID"]
    start: Scalars["Int"]
    title: Scalars["String"]
}

export type CollectionItemPagination = Pagination & {
    __typename?: "CollectionItemPagination"
    first: Scalars["Int"]
    items: Array<Item>
    offset: Scalars["Int"]
    total: Scalars["Int"]
}

export type Config = {
    __typename?: "Config"
    app: AppConfig
    global: GlobalConfig
}

export type ConfigAppArgs = {
    timestamp?: InputMaybe<Scalars["String"]>
}

export type ConfigGlobalArgs = {
    timestamp?: InputMaybe<Scalars["String"]>
}

export type Episode = {
    __typename?: "Episode"
    audioLanguages: Array<Language>
    chapters: Array<Chapter>
    description: Scalars["String"]
    duration: Scalars["Int"]
    extraDescription: Scalars["String"]
    files: Array<File>
    id: Scalars["ID"]
    legacyID?: Maybe<Scalars["ID"]>
    number?: Maybe<Scalars["Int"]>
    season?: Maybe<Season>
    streams: Array<Stream>
    subtitleLanguages: Array<Language>
    title: Scalars["String"]
}

export type EpisodeCalendarEntry = CalendarEntry & {
    __typename?: "EpisodeCalendarEntry"
    description: Scalars["String"]
    end: Scalars["Date"]
    episode?: Maybe<Episode>
    event?: Maybe<Event>
    id: Scalars["ID"]
    start: Scalars["Date"]
    title: Scalars["String"]
}

export type EpisodeItem = Item & {
    __typename?: "EpisodeItem"
    episode: Episode
    id: Scalars["ID"]
    imageUrl?: Maybe<Scalars["String"]>
    sort: Scalars["Int"]
    title: Scalars["String"]
}

export type EpisodePagination = Pagination & {
    __typename?: "EpisodePagination"
    first: Scalars["Int"]
    items: Array<Episode>
    offset: Scalars["Int"]
    total: Scalars["Int"]
}

export type EpisodeSearchItem = SearchResultItem & {
    __typename?: "EpisodeSearchItem"
    collection: Scalars["String"]
    description?: Maybe<Scalars["String"]>
    header?: Maybe<Scalars["String"]>
    highlight?: Maybe<Scalars["String"]>
    id: Scalars["ID"]
    image?: Maybe<Scalars["String"]>
    legacyID?: Maybe<Scalars["ID"]>
    season?: Maybe<Season>
    seasonId?: Maybe<Scalars["ID"]>
    seasonTitle?: Maybe<Scalars["String"]>
    show?: Maybe<Show>
    showId?: Maybe<Scalars["ID"]>
    showTitle?: Maybe<Scalars["String"]>
    title: Scalars["String"]
    url: Scalars["String"]
}

export type Event = {
    __typename?: "Event"
    end: Scalars["String"]
    id: Scalars["ID"]
    image: Scalars["String"]
    start: Scalars["String"]
    title: Scalars["String"]
}

export type Faq = {
    __typename?: "FAQ"
    categories?: Maybe<FaqCategoryPagination>
    category: FaqCategory
    question: Question
}

export type FaqCategoriesArgs = {
    Offset?: InputMaybe<Scalars["Int"]>
    first?: InputMaybe<Scalars["Int"]>
}

export type FaqCategoryArgs = {
    id: Scalars["ID"]
}

export type FaqQuestionArgs = {
    id: Scalars["ID"]
}

export type FaqCategory = {
    __typename?: "FAQCategory"
    id: Scalars["ID"]
    questions?: Maybe<QuestionPagination>
    title: Scalars["String"]
}

export type FaqCategoryQuestionsArgs = {
    first?: InputMaybe<Scalars["Int"]>
    offset?: InputMaybe<Scalars["Int"]>
}

export type FaqCategoryPagination = Pagination & {
    __typename?: "FAQCategoryPagination"
    first: Scalars["Int"]
    items: Array<FaqCategory>
    offset: Scalars["Int"]
    total: Scalars["Int"]
}

export type File = {
    __typename?: "File"
    audioLanguage: Language
    fileName: Scalars["String"]
    id: Scalars["ID"]
    mimeType: Scalars["String"]
    size?: Maybe<Scalars["Int"]>
    subtitleLanguage?: Maybe<Language>
    url: Scalars["String"]
}

export type GlobalConfig = {
    __typename?: "GlobalConfig"
    liveOnline: Scalars["Boolean"]
    npawEnabled: Scalars["Boolean"]
}

export type Item = {
    id: Scalars["ID"]
    imageUrl?: Maybe<Scalars["String"]>
    sort: Scalars["Int"]
    title: Scalars["String"]
}

export type ItemSection = Section & {
    __typename?: "ItemSection"
    id: Scalars["ID"]
    items: CollectionItemPagination
    page: Page
    title: Scalars["String"]
    type: ItemSectionType
}

export type ItemSectionItemsArgs = {
    first?: InputMaybe<Scalars["Int"]>
    offset?: InputMaybe<Scalars["Int"]>
}

export enum ItemSectionType {
    Cards = "cards",
    Slider = "slider",
}

export enum Language {
    De = "de",
    En = "en",
    No = "no",
}

export type MaintenanceMessage = {
    __typename?: "MaintenanceMessage"
    details?: Maybe<Scalars["String"]>
    message: Scalars["String"]
}

export type Messages = {
    __typename?: "Messages"
    maintenance: Array<MaintenanceMessage>
}

export type MessagesMaintenanceArgs = {
    timestamp?: InputMaybe<Scalars["String"]>
}

export type Page = {
    __typename?: "Page"
    code: Scalars["String"]
    description?: Maybe<Scalars["String"]>
    id: Scalars["ID"]
    sections: SectionPagination
    title: Scalars["String"]
}

export type PageSectionsArgs = {
    first?: InputMaybe<Scalars["Int"]>
    offset?: InputMaybe<Scalars["Int"]>
}

export type PageItem = Item & {
    __typename?: "PageItem"
    id: Scalars["ID"]
    imageUrl?: Maybe<Scalars["String"]>
    page: Page
    sort: Scalars["Int"]
    title: Scalars["String"]
}

export type PagePagination = Pagination & {
    __typename?: "PagePagination"
    first: Scalars["Int"]
    items: Array<Page>
    offset: Scalars["Int"]
    total: Scalars["Int"]
}

export type Pagination = {
    first: Scalars["Int"]
    offset: Scalars["Int"]
    total: Scalars["Int"]
}

export type QueryRoot = {
    __typename?: "QueryRoot"
    calendar?: Maybe<Calendar>
    config: Config
    episode?: Maybe<Episode>
    event?: Maybe<Event>
    faq: Faq
    me: User
    messages: Messages
    page?: Maybe<Page>
    search: SearchResult
    season?: Maybe<Season>
    section?: Maybe<Section>
    show?: Maybe<Show>
}

export type QueryRootEpisodeArgs = {
    id: Scalars["ID"]
}

export type QueryRootEventArgs = {
    id: Scalars["ID"]
}

export type QueryRootPageArgs = {
    code?: InputMaybe<Scalars["String"]>
    id?: InputMaybe<Scalars["ID"]>
}

export type QueryRootSearchArgs = {
    first?: InputMaybe<Scalars["Int"]>
    offset?: InputMaybe<Scalars["Int"]>
    queryString: Scalars["String"]
}

export type QueryRootSeasonArgs = {
    id: Scalars["ID"]
}

export type QueryRootSectionArgs = {
    id: Scalars["ID"]
}

export type QueryRootShowArgs = {
    id: Scalars["ID"]
}

export type Question = {
    __typename?: "Question"
    answer: Scalars["String"]
    category: FaqCategory
    id: Scalars["ID"]
    question: Scalars["String"]
}

export type QuestionPagination = Pagination & {
    __typename?: "QuestionPagination"
    first: Scalars["Int"]
    items: Array<Question>
    offset: Scalars["Int"]
    total: Scalars["Int"]
}

export type SearchResult = {
    __typename?: "SearchResult"
    hits: Scalars["Int"]
    page: Scalars["Int"]
    result: Array<SearchResultItem>
}

export type SearchResultItem = {
    collection: Scalars["String"]
    description?: Maybe<Scalars["String"]>
    header?: Maybe<Scalars["String"]>
    highlight?: Maybe<Scalars["String"]>
    id: Scalars["ID"]
    image?: Maybe<Scalars["String"]>
    legacyID?: Maybe<Scalars["ID"]>
    title: Scalars["String"]
    url: Scalars["String"]
}

export type Season = {
    __typename?: "Season"
    description: Scalars["String"]
    episodes: EpisodePagination
    id: Scalars["ID"]
    legacyID?: Maybe<Scalars["ID"]>
    number: Scalars["Int"]
    show: Show
    title: Scalars["String"]
}

export type SeasonEpisodesArgs = {
    first?: InputMaybe<Scalars["Int"]>
    offset?: InputMaybe<Scalars["Int"]>
}

export type SeasonCalendarEntry = CalendarEntry & {
    __typename?: "SeasonCalendarEntry"
    description: Scalars["String"]
    end: Scalars["Date"]
    event?: Maybe<Event>
    id: Scalars["ID"]
    season?: Maybe<Season>
    start: Scalars["Date"]
    title: Scalars["String"]
}

export type SeasonItem = Item & {
    __typename?: "SeasonItem"
    id: Scalars["ID"]
    imageUrl: Scalars["String"]
    season: Season
    sort: Scalars["Int"]
    title: Scalars["String"]
}

export type SeasonPagination = Pagination & {
    __typename?: "SeasonPagination"
    first: Scalars["Int"]
    items: Array<Season>
    offset: Scalars["Int"]
    total: Scalars["Int"]
}

export type SeasonSearchItem = SearchResultItem & {
    __typename?: "SeasonSearchItem"
    collection: Scalars["String"]
    description?: Maybe<Scalars["String"]>
    header?: Maybe<Scalars["String"]>
    highlight?: Maybe<Scalars["String"]>
    id: Scalars["ID"]
    image?: Maybe<Scalars["String"]>
    legacyID?: Maybe<Scalars["ID"]>
    show: Show
    showId: Scalars["ID"]
    showTitle: Scalars["String"]
    title: Scalars["String"]
    url: Scalars["String"]
}

export type Section = {
    id: Scalars["ID"]
    title: Scalars["String"]
}

export type SectionPagination = Pagination & {
    __typename?: "SectionPagination"
    first: Scalars["Int"]
    items: Array<Section>
    offset: Scalars["Int"]
    total: Scalars["Int"]
}

export type Settings = {
    __typename?: "Settings"
    audioLanguages: Array<Language>
    subtitleLanguages: Array<Language>
}

export type Show = {
    __typename?: "Show"
    description: Scalars["String"]
    episodeCount: Scalars["Int"]
    id: Scalars["ID"]
    legacyID?: Maybe<Scalars["ID"]>
    seasonCount: Scalars["Int"]
    seasons: SeasonPagination
    title: Scalars["String"]
}

export type ShowSeasonsArgs = {
    first?: InputMaybe<Scalars["Int"]>
    offset?: InputMaybe<Scalars["Int"]>
}

export type ShowCalendarEntry = CalendarEntry & {
    __typename?: "ShowCalendarEntry"
    description: Scalars["String"]
    end: Scalars["Date"]
    event?: Maybe<Event>
    id: Scalars["ID"]
    show?: Maybe<Show>
    start: Scalars["Date"]
    title: Scalars["String"]
}

export type ShowItem = Item & {
    __typename?: "ShowItem"
    id: Scalars["ID"]
    imageUrl?: Maybe<Scalars["String"]>
    show: Show
    sort: Scalars["Int"]
    title: Scalars["String"]
}

export type ShowPagination = Pagination & {
    __typename?: "ShowPagination"
    first: Scalars["Int"]
    items: Array<Show>
    offset: Scalars["Int"]
    total: Scalars["Int"]
}

export type ShowSearchItem = SearchResultItem & {
    __typename?: "ShowSearchItem"
    collection: Scalars["String"]
    description?: Maybe<Scalars["String"]>
    header?: Maybe<Scalars["String"]>
    highlight?: Maybe<Scalars["String"]>
    id: Scalars["ID"]
    image?: Maybe<Scalars["String"]>
    legacyID?: Maybe<Scalars["ID"]>
    title: Scalars["String"]
    url: Scalars["String"]
}

export type SimpleCalendarEntry = CalendarEntry & {
    __typename?: "SimpleCalendarEntry"
    description: Scalars["String"]
    end: Scalars["Date"]
    event?: Maybe<Event>
    id: Scalars["ID"]
    start: Scalars["Date"]
    title: Scalars["String"]
}

export type Stream = {
    __typename?: "Stream"
    audioLanguages: Array<Language>
    id: Scalars["ID"]
    subtitleLanguages: Array<Language>
    type: StreamType
    url: Scalars["String"]
}

export enum StreamType {
    Cmaf = "cmaf",
    Dash = "dash",
    Hls = "hls",
}

export type UrlItem = Item & {
    __typename?: "URLItem"
    id: Scalars["ID"]
    imageUrl?: Maybe<Scalars["String"]>
    sort: Scalars["Int"]
    title: Scalars["String"]
    url: Scalars["String"]
}

export type User = {
    __typename?: "User"
    anonymous: Scalars["Boolean"]
    audience?: Maybe<Scalars["String"]>
    bccMember: Scalars["Boolean"]
    email?: Maybe<Scalars["String"]>
    id?: Maybe<Scalars["ID"]>
    roles: Array<Scalars["String"]>
    settings: Settings
}

export type GetPageQueryVariables = Exact<{
    code: Scalars["String"]
}>

export type GetPageQuery = {
    __typename?: "QueryRoot"
    page?: {
        __typename?: "Page"
        id: string
        title: string
        sections: {
            __typename?: "SectionPagination"
            items: Array<{
                __typename?: "ItemSection"
                id: string
                title: string
                items: {
                    __typename?: "CollectionItemPagination"
                    items: Array<
                        | {
                              __typename?: "EpisodeItem"
                              id: string
                              title: string
                              imageUrl?: string | null
                              sort: number
                              episode: {
                                  __typename?: "Episode"
                                  number?: number | null
                                  season?: {
                                      __typename?: "Season"
                                      number: number
                                      show: {
                                          __typename?: "Show"
                                          title: string
                                      }
                                  } | null
                              }
                          }
                        | {
                              __typename?: "PageItem"
                              id: string
                              title: string
                              imageUrl?: string | null
                              sort: number
                          }
                        | {
                              __typename?: "SeasonItem"
                              id: string
                              title: string
                              imageUrl: string
                              sort: number
                              season: {
                                  __typename?: "Season"
                                  number: number
                                  show: { __typename?: "Show"; title: string }
                              }
                          }
                        | {
                              __typename?: "ShowItem"
                              id: string
                              title: string
                              imageUrl?: string | null
                              sort: number
                          }
                        | {
                              __typename?: "URLItem"
                              id: string
                              title: string
                              imageUrl?: string | null
                              sort: number
                          }
                    >
                }
            }>
        }
    } | null
}

export type GetSectionQueryVariables = Exact<{
    id: Scalars["ID"]
}>

export type GetSectionQuery = {
    __typename?: "QueryRoot"
    section?: {
        __typename?: "ItemSection"
        id: string
        title: string
        items: {
            __typename?: "CollectionItemPagination"
            items: Array<
                | {
                      __typename?: "EpisodeItem"
                      id: string
                      imageUrl?: string | null
                      title: string
                      sort: number
                  }
                | {
                      __typename?: "PageItem"
                      id: string
                      imageUrl?: string | null
                      title: string
                      sort: number
                  }
                | {
                      __typename?: "SeasonItem"
                      id: string
                      imageUrl: string
                      title: string
                      sort: number
                  }
                | {
                      __typename?: "ShowItem"
                      id: string
                      imageUrl?: string | null
                      title: string
                      sort: number
                  }
                | {
                      __typename?: "URLItem"
                      id: string
                      imageUrl?: string | null
                      title: string
                      sort: number
                  }
            >
        }
    } | null
}

export const GetPageDocument = gql`
    query getPage($code: String!) {
        page(code: $code) {
            id
            title
            sections {
                items {
                    id
                    title
                    ... on ItemSection {
                        items {
                            items {
                                id
                                title
                                imageUrl
                                sort
                                ... on EpisodeItem {
                                    episode {
                                        number
                                        season {
                                            show {
                                                title
                                            }
                                            number
                                        }
                                    }
                                }
                                ... on SeasonItem {
                                    season {
                                        number
                                        show {
                                            title
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
`

export function useGetPageQuery(
    options: Omit<Urql.UseQueryArgs<never, GetPageQueryVariables>, "query"> = {}
) {
    return Urql.useQuery<GetPageQuery>({ query: GetPageDocument, ...options })
}
export const GetSectionDocument = gql`
    query getSection($id: ID!) {
        section(id: $id) {
            id
            title
            ... on ItemSection {
                items {
                    items {
                        id
                        imageUrl
                        title
                        sort
                    }
                }
            }
        }
    }
`

export function useGetSectionQuery(
    options: Omit<
        Urql.UseQueryArgs<never, GetSectionQueryVariables>,
        "query"
    > = {}
) {
    return Urql.useQuery<GetSectionQuery>({
        query: GetSectionDocument,
        ...options,
    })
}
