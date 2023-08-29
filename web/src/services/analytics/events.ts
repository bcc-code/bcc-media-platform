import { GetPageQuery, SectionItemFragment } from "@/graph/generated"

type StringWithAutocomplete<T> = T | (string & {})

export type Page = StringWithAutocomplete<
    | "about"
    | "calendar"
    | "livestream"
    | "login"
    | "profileEdit"
    | "profile"
    | "search"
    | "settings"
    | "support"
    | "faq"
    | "episode"
>

export type IdentifyData = {
    id: string
    ageGroup: string
    country: string
    churchId: string
    gender: string
}

export type AgeGroup =
    | "UNKNOWN"
    | "< 10"
    | "10 - 12"
    | "13 - 18"
    | "19 - 25"
    | "26 - 36"
    | "37 - 50"
    | "51 - 64"
    | "65+"

type ElementType = SectionItemFragment["item"]["__typename"]

type VideoEvent = {
    sessionId: string
    livestream: boolean
    contentPodId: string
    position?: number
    totalLength: number
    videoPlayer: "videojs"
    fullScreen: boolean
    hasVideo: true
}

export type Events = {
    section_clicked: {
        sectionId: string
        sectionName: string
        sectionPosition: number
        sectionType: GetPageQuery["page"]["sections"]["items"][0]["__typename"]
        elementPosition: number
        elementType: ElementType
        elementId: string
        elementName: string
        pageCode: Page
    }
    audioonly_clicked: {
        audioOnly: boolean
    }
    calendarday_clicked: {
        pageCode: Page
        calendarView: "week" | "month"
        calendarDate: string
    }
    search_performed: {
        searchText: string
        /** in milliseconds */
        searchLatency: number
        searchResultCount: number
    }
    searchresult_clicked: {
        searchText: string
        elementPosition: number
        elementType: ElementType
        elementId: string
        group: "shows" | "episodes"
    }
    language_changed: {
        pageCode: string
        languageFrom: string
        languageTo: string
    }
    application_opened: {
        reason: string
        coldStart: boolean
    }
    content_shared: {
        pageCode: Page
        elementType: ElementType
        elementId: string
        position?: number
    }
    login: undefined
    logout: undefined
    airplay_started: undefined
    chromecast_started: undefined
    playback_started: VideoEvent
    playback_paused: VideoEvent
    playback_ended: VideoEvent
    playback_interrupted: VideoEvent
    playback_buffering_started: VideoEvent
    episode_download: {
        episodeId: string
        fileName: string
        audioLanguage: string
        resolution: string
    }
}
