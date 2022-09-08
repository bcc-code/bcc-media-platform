import { GetPageQuery } from "@/graph/generated"

export type Section = NonNullable<GetPageQuery["page"]>["sections"]["items"][0]

export type SectionItem = Section["items"]["items"][0]
