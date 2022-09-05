import gql from 'graphql-tag';
import * as Urql from '@urql/vue';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
  Cursor: any;
  Date: any;
};

export type AppConfig = {
  minVersion: Scalars['String'];
};

export type Calendar = {
  day?: Maybe<CalendarDay>;
  period?: Maybe<CalendarPeriod>;
};


export type CalendarDayArgs = {
  day: Scalars['Date'];
};


export type CalendarPeriodArgs = {
  from: Scalars['Date'];
  to: Scalars['Date'];
};

export type CalendarDay = {
  entries: Array<CalendarEntry>;
  events: Array<Event>;
};

export type CalendarEntry = {
  description: Scalars['String'];
  end: Scalars['Date'];
  event?: Maybe<Event>;
  id: Scalars['ID'];
  start: Scalars['Date'];
  title: Scalars['String'];
};

export type CalendarPeriod = {
  activeDays: Array<Scalars['Date']>;
  events: Array<Event>;
};

export type Chapter = {
  id: Scalars['ID'];
  start: Scalars['Int'];
  title: Scalars['String'];
};

export type Collection = {
  id: Scalars['ID'];
  items?: Maybe<CollectionItemPagination>;
};


export type CollectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type CollectionItemPagination = Pagination & {
  first: Scalars['Int'];
  items: Array<Item>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type Config = {
  app: AppConfig;
  global: GlobalConfig;
};


export type ConfigAppArgs = {
  timestamp?: InputMaybe<Scalars['String']>;
};


export type ConfigGlobalArgs = {
  timestamp?: InputMaybe<Scalars['String']>;
};

export type Episode = {
  audioLanguages: Array<Language>;
  chapters: Array<Chapter>;
  description: Scalars['String'];
  duration: Scalars['Int'];
  extraDescription: Scalars['String'];
  files: Array<File>;
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  legacyID?: Maybe<Scalars['ID']>;
  number?: Maybe<Scalars['Int']>;
  season?: Maybe<Season>;
  streams: Array<Stream>;
  subtitleLanguages: Array<Language>;
  title: Scalars['String'];
};

export type EpisodeCalendarEntry = CalendarEntry & {
  description: Scalars['String'];
  end: Scalars['Date'];
  episode?: Maybe<Episode>;
  event?: Maybe<Event>;
  id: Scalars['ID'];
  start: Scalars['Date'];
  title: Scalars['String'];
};

export type EpisodeItem = Item & {
  episode: Episode;
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  sort: Scalars['Int'];
  title: Scalars['String'];
};

export type EpisodePagination = Pagination & {
  first: Scalars['Int'];
  items: Array<Episode>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type EpisodeSearchItem = SearchResultItem & {
  collection: Scalars['String'];
  description?: Maybe<Scalars['String']>;
  header?: Maybe<Scalars['String']>;
  highlight?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  legacyID?: Maybe<Scalars['ID']>;
  season?: Maybe<Season>;
  seasonId?: Maybe<Scalars['ID']>;
  seasonTitle?: Maybe<Scalars['String']>;
  show?: Maybe<Show>;
  showId?: Maybe<Scalars['ID']>;
  showTitle?: Maybe<Scalars['String']>;
  title: Scalars['String'];
  url: Scalars['String'];
};

export type Event = {
  end: Scalars['String'];
  id: Scalars['ID'];
  image: Scalars['String'];
  start: Scalars['String'];
  title: Scalars['String'];
};

export type Faq = {
  categories?: Maybe<FaqCategoryPagination>;
  category: FaqCategory;
  question: Question;
};


export type FaqCategoriesArgs = {
  Offset?: InputMaybe<Scalars['Int']>;
  first?: InputMaybe<Scalars['Int']>;
};


export type FaqCategoryArgs = {
  id: Scalars['ID'];
};


export type FaqQuestionArgs = {
  id: Scalars['ID'];
};

export type FaqCategory = {
  id: Scalars['ID'];
  questions?: Maybe<QuestionPagination>;
  title: Scalars['String'];
};


export type FaqCategoryQuestionsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type FaqCategoryPagination = Pagination & {
  first: Scalars['Int'];
  items: Array<FaqCategory>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type File = {
  audioLanguage: Language;
  fileName: Scalars['String'];
  id: Scalars['ID'];
  mimeType: Scalars['String'];
  size?: Maybe<Scalars['Int']>;
  subtitleLanguage?: Maybe<Language>;
  url: Scalars['String'];
};

export type GlobalConfig = {
  liveOnline: Scalars['Boolean'];
  npawEnabled: Scalars['Boolean'];
};

export type Item = {
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  sort: Scalars['Int'];
  title: Scalars['String'];
};

export type ItemSection = Section & {
  id: Scalars['ID'];
  items: CollectionItemPagination;
  page: Page;
  title: Scalars['String'];
  type: ItemSectionType;
};


export type ItemSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export enum ItemSectionType {
  Cards = 'cards',
  Slider = 'slider'
}

export enum Language {
  De = 'de',
  En = 'en',
  No = 'no'
}

export type MaintenanceMessage = {
  details?: Maybe<Scalars['String']>;
  message: Scalars['String'];
};

export type Messages = {
  maintenance: Array<MaintenanceMessage>;
};


export type MessagesMaintenanceArgs = {
  timestamp?: InputMaybe<Scalars['String']>;
};

export type Page = {
  code: Scalars['String'];
  description?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  sections: SectionPagination;
  title: Scalars['String'];
};


export type PageSectionsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type PageItem = Item & {
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  page: Page;
  sort: Scalars['Int'];
  title: Scalars['String'];
};

export type PagePagination = Pagination & {
  first: Scalars['Int'];
  items: Array<Page>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type Pagination = {
  first: Scalars['Int'];
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type QueryRoot = {
  calendar?: Maybe<Calendar>;
  collection?: Maybe<Collection>;
  config: Config;
  episode?: Maybe<Episode>;
  event?: Maybe<Event>;
  faq: Faq;
  me: User;
  messages: Messages;
  page?: Maybe<Page>;
  search: SearchResult;
  season?: Maybe<Season>;
  section?: Maybe<Section>;
  show?: Maybe<Show>;
};


export type QueryRootCollectionArgs = {
  id: Scalars['ID'];
};


export type QueryRootEpisodeArgs = {
  id: Scalars['ID'];
};


export type QueryRootEventArgs = {
  id: Scalars['ID'];
};


export type QueryRootPageArgs = {
  code?: InputMaybe<Scalars['String']>;
  id?: InputMaybe<Scalars['ID']>;
};


export type QueryRootSearchArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
  queryString: Scalars['String'];
};


export type QueryRootSeasonArgs = {
  id: Scalars['ID'];
};


export type QueryRootSectionArgs = {
  id: Scalars['ID'];
};


export type QueryRootShowArgs = {
  id: Scalars['ID'];
};

export type Question = {
  answer: Scalars['String'];
  category: FaqCategory;
  id: Scalars['ID'];
  question: Scalars['String'];
};

export type QuestionPagination = Pagination & {
  first: Scalars['Int'];
  items: Array<Question>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type SearchResult = {
  hits: Scalars['Int'];
  page: Scalars['Int'];
  result: Array<SearchResultItem>;
};

export type SearchResultItem = {
  collection: Scalars['String'];
  description?: Maybe<Scalars['String']>;
  header?: Maybe<Scalars['String']>;
  highlight?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  legacyID?: Maybe<Scalars['ID']>;
  title: Scalars['String'];
  url: Scalars['String'];
};

export type Season = {
  description: Scalars['String'];
  episodes: EpisodePagination;
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  legacyID?: Maybe<Scalars['ID']>;
  number: Scalars['Int'];
  show: Show;
  title: Scalars['String'];
};


export type SeasonEpisodesArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type SeasonCalendarEntry = CalendarEntry & {
  description: Scalars['String'];
  end: Scalars['Date'];
  event?: Maybe<Event>;
  id: Scalars['ID'];
  season?: Maybe<Season>;
  start: Scalars['Date'];
  title: Scalars['String'];
};

export type SeasonItem = Item & {
  id: Scalars['ID'];
  imageUrl: Scalars['String'];
  season: Season;
  sort: Scalars['Int'];
  title: Scalars['String'];
};

export type SeasonPagination = Pagination & {
  first: Scalars['Int'];
  items: Array<Season>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type SeasonSearchItem = SearchResultItem & {
  collection: Scalars['String'];
  description?: Maybe<Scalars['String']>;
  header?: Maybe<Scalars['String']>;
  highlight?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  legacyID?: Maybe<Scalars['ID']>;
  show: Show;
  showId: Scalars['ID'];
  showTitle: Scalars['String'];
  title: Scalars['String'];
  url: Scalars['String'];
};

export type Section = {
  id: Scalars['ID'];
  title: Scalars['String'];
};

export type SectionPagination = Pagination & {
  first: Scalars['Int'];
  items: Array<Section>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type Settings = {
  audioLanguages: Array<Language>;
  subtitleLanguages: Array<Language>;
};

export type Show = {
  description: Scalars['String'];
  episodeCount: Scalars['Int'];
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  legacyID?: Maybe<Scalars['ID']>;
  seasonCount: Scalars['Int'];
  seasons: SeasonPagination;
  title: Scalars['String'];
};


export type ShowSeasonsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type ShowCalendarEntry = CalendarEntry & {
  description: Scalars['String'];
  end: Scalars['Date'];
  event?: Maybe<Event>;
  id: Scalars['ID'];
  show?: Maybe<Show>;
  start: Scalars['Date'];
  title: Scalars['String'];
};

export type ShowItem = Item & {
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  show: Show;
  sort: Scalars['Int'];
  title: Scalars['String'];
};

export type ShowPagination = Pagination & {
  first: Scalars['Int'];
  items: Array<Show>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type ShowSearchItem = SearchResultItem & {
  collection: Scalars['String'];
  description?: Maybe<Scalars['String']>;
  header?: Maybe<Scalars['String']>;
  highlight?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  legacyID?: Maybe<Scalars['ID']>;
  title: Scalars['String'];
  url: Scalars['String'];
};

export type SimpleCalendarEntry = CalendarEntry & {
  description: Scalars['String'];
  end: Scalars['Date'];
  event?: Maybe<Event>;
  id: Scalars['ID'];
  start: Scalars['Date'];
  title: Scalars['String'];
};

export type Stream = {
  audioLanguages: Array<Language>;
  id: Scalars['ID'];
  subtitleLanguages: Array<Language>;
  type: StreamType;
  url: Scalars['String'];
};

export enum StreamType {
  Cmaf = 'cmaf',
  Dash = 'dash',
  Hls = 'hls'
}

export type UrlItem = Item & {
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  sort: Scalars['Int'];
  title: Scalars['String'];
  url: Scalars['String'];
};

export type User = {
  anonymous: Scalars['Boolean'];
  audience?: Maybe<Scalars['String']>;
  bccMember: Scalars['Boolean'];
  email?: Maybe<Scalars['String']>;
  id?: Maybe<Scalars['ID']>;
  roles: Array<Scalars['String']>;
  settings: Settings;
};

export type GetEpisodeQueryVariables = Exact<{
  episodeId: Scalars['ID'];
}>;


export type GetEpisodeQuery = { episode?: { id: string, title: string, description: string, imageUrl?: string | null, number?: number | null, season?: { title: string, number: number, show: { title: string } } | null } | null };

export type GetPageQueryVariables = Exact<{
  code: Scalars['String'];
}>;


export type GetPageQuery = { page?: { id: string, title: string, sections: { items: Array<{ id: string, title: string, items: { items: Array<{ __typename: 'EpisodeItem', id: string, title: string, imageUrl?: string | null, sort: number, episode: { number?: number | null, season?: { number: number, show: { title: string } } | null } } | { __typename: 'PageItem', id: string, title: string, imageUrl?: string | null, sort: number, page: { code: string } } | { __typename: 'SeasonItem', id: string, title: string, imageUrl: string, sort: number, season: { number: number, show: { title: string } } } | { __typename: 'ShowItem', id: string, title: string, imageUrl?: string | null, sort: number } | { __typename: 'URLItem', id: string, title: string, imageUrl?: string | null, sort: number }> } }> } } | null };

export type GetSectionQueryVariables = Exact<{
  id: Scalars['ID'];
}>;


export type GetSectionQuery = { section?: { id: string, title: string, items: { items: Array<{ __typename: 'EpisodeItem', id: string, imageUrl?: string | null, title: string, sort: number } | { __typename: 'PageItem', id: string, imageUrl?: string | null, title: string, sort: number } | { __typename: 'SeasonItem', id: string, imageUrl: string, title: string, sort: number } | { __typename: 'ShowItem', id: string, imageUrl?: string | null, title: string, sort: number } | { __typename: 'URLItem', id: string, imageUrl?: string | null, title: string, sort: number }> } } | null };


export const GetEpisodeDocument = gql`
    query getEpisode($episodeId: ID!) {
  episode(id: $episodeId) {
    id
    title
    description
    imageUrl
    number
    season {
      title
      number
      show {
        title
      }
    }
  }
}
    `;

export function useGetEpisodeQuery(options: Omit<Urql.UseQueryArgs<never, GetEpisodeQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetEpisodeQuery>({ query: GetEpisodeDocument, ...options });
};
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
              __typename
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
              ... on PageItem {
                page {
                  code
                }
              }
            }
          }
        }
      }
    }
  }
}
    `;

export function useGetPageQuery(options: Omit<Urql.UseQueryArgs<never, GetPageQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetPageQuery>({ query: GetPageDocument, ...options });
};
export const GetSectionDocument = gql`
    query getSection($id: ID!) {
  section(id: $id) {
    id
    title
    ... on ItemSection {
      items {
        items {
          __typename
          id
          imageUrl
          title
          sort
        }
      }
    }
  }
}
    `;

export function useGetSectionQuery(options: Omit<Urql.UseQueryArgs<never, GetSectionQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetSectionQuery>({ query: GetSectionDocument, ...options });
};