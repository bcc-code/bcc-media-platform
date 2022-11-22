type Data = {}

type SectionData = {
    id: string
} & (
    | {
          type: "message" | "embed_web"
      }
    | {
          type: "item"
          style:
              | "default"
              | "grid"
              | "featured"
              | "message"
              | "poster"
              | "poster_grid"
              | "icon"
              | "label"
      }
)

type SectionElementData = {
    id: string
    position: number
    type: "show" | "season" | "episode" | "page" | "link"
    name: string

    sectionId: string
    sectionType: string
    sectionName: string
}

export type AgeGroup =
    | "UNKNOWN"
    | "< 10"
    | "10 - 12"
    | "13 - 18"
    | "19 - 26"
    | "27 - 36"
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
        "26": "19 - 26",
        "36": "27 - 36",
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

export type Events = {
    calendar_opened: Data
    calendarday_clicked: Data
    search_performed: Data
    searchitem_clicked: Data
    section_viewed: SectionData
    sectionelement_clicked: SectionElementData
    sectionelement_viewed: SectionElementData
}
