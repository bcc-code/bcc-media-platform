import { GetPageQuery } from '@/graph/generated'

export type Section = NonNullable<GetPageQuery['page']>['sections']['items'][0]
