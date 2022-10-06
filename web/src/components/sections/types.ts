import { GetPageQuery, ItemSection, PageItemFragment, SectionFragment } from "@/graph/generated"

export type Section = NonNullable<GetPageQuery["page"]>["sections"]["items"][0]

export type SectionItem = SectionFragment["items"]["items"][0]
