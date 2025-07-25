import { GetPageQuery, SectionItemFragment } from '@/graph/generated'
import { apiObject } from 'rudder-sdk-js'

type StringWithAutocomplete<T> = T | (string & {})

export type Page = StringWithAutocomplete<
    | 'about'
    | 'calendar'
    | 'login'
    | 'profileEdit'
    | 'profile'
    | 'search'
    | 'settings'
    | 'support'
    | 'faq'
    | 'episode'
    | 'comic'
    | 'show'
>

export type IdentifyData = {
    id: string
    ageGroup?: string
    country?: string
    churchId?: string
    gender?: string
}

export type AgeGroup =
    | 'UNKNOWN'
    | '< 10'
    | '10 - 12'
    | '13 - 18'
    | '19 - 25'
    | '26 - 36'
    | '37 - 50'
    | '51 - 64'
    | '65+'

type ElementType = SectionItemFragment['item']['__typename'] | 'Comic' | 'Quote'

export type Events = {
    section_clicked: {
        sectionId: string
        sectionName?: string
        sectionPosition: number
        sectionType: GetPageQuery['page']['sections']['items'][0]['__typename']
        elementPosition: number
        elementType: ElementType
        elementId: string
        elementName?: string
        pageCode: Page
    }
    audioonly_clicked: {
        audioOnly: boolean
    }
    calendarday_clicked: {
        pageCode: Page
        calendarView: 'week' | 'month'
        calendarDate: string
    }
    search_performed: {
        searchText: string
        /** in milliseconds */
        searchLatency: number
        searchResultCount: number
        sessionId: string
        searchSessionId: string
    }
    searchresult_clicked: {
        searchText: string
        elementPosition: number
        elementType: ElementType
        elementId: string
        group: 'shows' | 'episodes'
        sessionId: string
        searchSessionId: string
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
    episode_download: {
        episodeId: string
        fileName: string
        audioLanguage: string
        resolution: string
    }
    interaction: {
        interaction: string
        contextElementType: ElementType
        contextElementId: string
        meta?: apiObject
    }
    viewing: {
        pageCode?: Page
        elementType?: ElementType
        elementId?: string
        meta?: apiObject
    }
    video_played: {
        videoId: string
        referenceId?: string
        data?: Record<string, never>
    }
    error: {
        message?: string
        code?: string | number
        data?: Record<string, any>
    }
    tasks_completed: {
        answers?: any
    }
}
