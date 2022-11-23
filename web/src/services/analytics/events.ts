import { GetPageQuery, SectionItemFragment } from "@/graph/generated"

export type Page =
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

export const getAgeGroup = (age?: number): AgeGroup => {
    const breakpoints: {
        [key: number]: AgeGroup
    } = {
        "9": "< 10",
        "12": "10 - 12",
        "18": "13 - 18",
        "25": "19 - 25",
        "36": "26 - 36",
        "50": "37 - 50",
        "64": "51 - 64",
    }

    if (age) {
        for (const [bp, v] of Object.entries(breakpoints)) {
            if (age <= parseInt(bp)) {
                return v
            }
        }
        return "65+"
    }
    return "UNKNOWN"
}

type ElementType = SectionItemFragment["item"]["__typename"]

type d = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0
type YYYY = `19${d}${d}` | `20${d}${d}`
type oneToNine = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
type MM = `0${oneToNine}` | `1${0 | 1 | 2}`
type DD = `${0}${oneToNine}` | `${1 | 2}${d}` | `3${0 | 1}`

export type Events = {
    section_clicked: {
        sectionId: string
        sectionName: string
        sectionPosition: string
        sectionType: GetPageQuery["page"]["sections"]["items"][0]["__typename"]
        elementPosition: string
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
        calendarDate: `${YYYY}-${MM}-${DD}`
    }
    search_performed: {
        searchText: string
        /** in milliseconds */
        searchLatency: number
        searchResultCount: number
    }
    searchresult_clicked: {
        searchText: string
        elementPosition: string
        elementType: ElementType
        elementId: string
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
    share_clicked: {
        pageCode: Page
        elementType: ElementType
        elementId: string
        position?: number
    }
    login: undefined
    logout: undefined
    airplay_started: undefined
    chromecast_started: undefined
}
