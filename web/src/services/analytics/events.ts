type Data = {

}

type SectionData = {
    id: string
} & ({
    type: "message" | "embed_web"
} | {
    type: "item"
    style: "default" | "grid" | "featured" | "message" | "poster" | "poster_grid" | "icon" | "label"
})

type SectionElementData = {
    id: string
    position: number
    type: "show" | "season" | "episode" | "page" | "link"
    name: string

    sectionId: string
    sectionType: string
    sectionName: string
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