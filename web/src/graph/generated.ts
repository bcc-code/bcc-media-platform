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

export type Analytics = {
  anonymousId: Scalars['String'];
};

export type Application = {
  clientVersion: Scalars['String'];
  code: Scalars['String'];
  id: Scalars['ID'];
  page?: Maybe<Page>;
  searchPage?: Maybe<Page>;
};

export type Calendar = {
  day: CalendarDay;
  period: CalendarPeriod;
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
  slug?: Maybe<Scalars['String']>;
};


export type CollectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type CollectionItem = {
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  images: Array<Image>;
  sort: Scalars['Int'];
  title: Scalars['String'];
};

export type CollectionItemPagination = Pagination & {
  first: Scalars['Int'];
  items: Array<CollectionItem>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type Config = {
  global: GlobalConfig;
};


export type ConfigGlobalArgs = {
  timestamp?: InputMaybe<Scalars['String']>;
};

export type ContextCollection = {
  id: Scalars['ID'];
  items?: Maybe<SectionItemPagination>;
  slug?: Maybe<Scalars['String']>;
};


export type ContextCollectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type DefaultGridSection = GridSection & ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: GridSectionSize;
  title?: Maybe<Scalars['String']>;
};


export type DefaultGridSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type DefaultSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: SectionSize;
  title?: Maybe<Scalars['String']>;
};


export type DefaultSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type Device = {
  token: Scalars['String'];
  updatedAt: Scalars['Date'];
};

export type Episode = {
  ageRating: Scalars['String'];
  audioLanguages: Array<Language>;
  availableFrom: Scalars['Date'];
  availableTo: Scalars['Date'];
  chapters: Array<Chapter>;
  context?: Maybe<EpisodeContextUnion>;
  description: Scalars['String'];
  duration: Scalars['Int'];
  extraDescription: Scalars['String'];
  files: Array<File>;
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  imageUrl?: Maybe<Scalars['String']>;
  images: Array<Image>;
  legacyID?: Maybe<Scalars['ID']>;
  legacyProgramID?: Maybe<Scalars['ID']>;
  number?: Maybe<Scalars['Int']>;
  productionDate?: Maybe<Scalars['String']>;
  progress?: Maybe<Scalars['Int']>;
  publishDate: Scalars['Date'];
  relatedItems?: Maybe<SectionItemPagination>;
  season?: Maybe<Season>;
  streams: Array<Stream>;
  subtitleLanguages: Array<Language>;
  title: Scalars['String'];
  type: EpisodeType;
};


export type EpisodeImageArgs = {
  style?: InputMaybe<ImageStyle>;
};


export type EpisodeRelatedItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
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

export type EpisodeContext = {
  collectionId?: InputMaybe<Scalars['String']>;
};

export type EpisodeContextUnion = ContextCollection | Season;

export type EpisodeItem = CollectionItem & {
  episode: Episode;
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  images: Array<Image>;
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
  ageRating: Scalars['String'];
  collection: Scalars['String'];
  description?: Maybe<Scalars['String']>;
  duration: Scalars['Int'];
  header?: Maybe<Scalars['String']>;
  highlight?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  legacyID?: Maybe<Scalars['ID']>;
  legacyProgramID?: Maybe<Scalars['ID']>;
  season?: Maybe<Season>;
  seasonId?: Maybe<Scalars['ID']>;
  seasonTitle?: Maybe<Scalars['String']>;
  show?: Maybe<Show>;
  showId?: Maybe<Scalars['ID']>;
  showTitle?: Maybe<Scalars['String']>;
  title: Scalars['String'];
  url: Scalars['String'];
};

export enum EpisodeType {
  Episode = 'episode',
  Standalone = 'standalone'
}

export type Event = {
  end: Scalars['String'];
  id: Scalars['ID'];
  image: Scalars['String'];
  start: Scalars['String'];
  title: Scalars['String'];
};

export type Export = {
  dbVersion: Scalars['String'];
  url: Scalars['String'];
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

export type FeaturedSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: SectionSize;
  title?: Maybe<Scalars['String']>;
};


export type FeaturedSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
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

export type GridSection = {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: GridSectionSize;
  title?: Maybe<Scalars['String']>;
};


export type GridSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export enum GridSectionSize {
  Half = 'half'
}

export type IconGridSection = GridSection & ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: GridSectionSize;
  title?: Maybe<Scalars['String']>;
};


export type IconGridSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type IconSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  title?: Maybe<Scalars['String']>;
};


export type IconSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type Image = {
  style: Scalars['String'];
  url: Scalars['String'];
};

export enum ImageStyle {
  Default = 'default',
  Featured = 'featured',
  Poster = 'poster'
}

export type ItemSection = {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  title?: Maybe<Scalars['String']>;
};


export type ItemSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type ItemSectionMetadata = {
  collectionId: Scalars['ID'];
  continueWatching: Scalars['Boolean'];
  prependLiveElement: Scalars['Boolean'];
  secondaryTitles: Scalars['Boolean'];
  useContext: Scalars['Boolean'];
};

export type LabelSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  title?: Maybe<Scalars['String']>;
};


export type LabelSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export enum Language {
  De = 'de',
  En = 'en',
  No = 'no'
}

export type LegacyIdLookup = {
  id: Scalars['ID'];
};

export type LegacyIdLookupOptions = {
  episodeID?: InputMaybe<Scalars['Int']>;
  programID?: InputMaybe<Scalars['Int']>;
};

export type Link = {
  id: Scalars['ID'];
  url: Scalars['String'];
};

export type ListSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: SectionSize;
  title?: Maybe<Scalars['String']>;
};


export type ListSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type Message = {
  content: Scalars['String'];
  style: MessageStyle;
  title: Scalars['String'];
};

export type MessageSection = Section & {
  id: Scalars['ID'];
  messages?: Maybe<Array<Message>>;
  metadata?: Maybe<ItemSectionMetadata>;
  title?: Maybe<Scalars['String']>;
};

export type MessageStyle = {
  background: Scalars['String'];
  border: Scalars['String'];
  text: Scalars['String'];
};

export type MutationRoot = {
  sendSupportEmail: Scalars['Boolean'];
  setDevicePushToken?: Maybe<Device>;
  setEpisodeProgress: Episode;
};


export type MutationRootSendSupportEmailArgs = {
  content: Scalars['String'];
  html: Scalars['String'];
  title: Scalars['String'];
};


export type MutationRootSetDevicePushTokenArgs = {
  languages: Array<Scalars['String']>;
  token: Scalars['String'];
};


export type MutationRootSetEpisodeProgressArgs = {
  context?: InputMaybe<EpisodeContext>;
  duration?: InputMaybe<Scalars['Int']>;
  id: Scalars['ID'];
  progress?: InputMaybe<Scalars['Int']>;
};

export type Page = {
  code: Scalars['String'];
  description?: Maybe<Scalars['String']>;
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  images: Array<Image>;
  sections: SectionPagination;
  title: Scalars['String'];
};


export type PageImageArgs = {
  style?: InputMaybe<ImageStyle>;
};


export type PageSectionsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type PageItem = CollectionItem & {
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  images: Array<Image>;
  page: Page;
  sort: Scalars['Int'];
  title: Scalars['String'];
};

export type Pagination = {
  first: Scalars['Int'];
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type PosterGridSection = GridSection & ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: GridSectionSize;
  title?: Maybe<Scalars['String']>;
};


export type PosterGridSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type PosterSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: SectionSize;
  title?: Maybe<Scalars['String']>;
};


export type PosterSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type Profile = {
  id: Scalars['ID'];
  name: Scalars['String'];
};

export type QueryRoot = {
  application: Application;
  calendar?: Maybe<Calendar>;
  collection: Collection;
  config: Config;
  episode: Episode;
  event?: Maybe<Event>;
  export: Export;
  faq: Faq;
  legacyIDLookup: LegacyIdLookup;
  me: User;
  page: Page;
  profile: Profile;
  profiles: Array<Profile>;
  redirect: RedirectLink;
  search: SearchResult;
  season: Season;
  section: Section;
  show: Show;
};


export type QueryRootCollectionArgs = {
  id?: InputMaybe<Scalars['ID']>;
  slug?: InputMaybe<Scalars['String']>;
};


export type QueryRootEpisodeArgs = {
  context?: InputMaybe<EpisodeContext>;
  id: Scalars['ID'];
};


export type QueryRootEventArgs = {
  id: Scalars['ID'];
};


export type QueryRootExportArgs = {
  groups?: InputMaybe<Array<Scalars['String']>>;
};


export type QueryRootLegacyIdLookupArgs = {
  options?: InputMaybe<LegacyIdLookupOptions>;
};


export type QueryRootPageArgs = {
  code?: InputMaybe<Scalars['String']>;
  id?: InputMaybe<Scalars['ID']>;
};


export type QueryRootRedirectArgs = {
  id: Scalars['String'];
};


export type QueryRootSearchArgs = {
  first?: InputMaybe<Scalars['Int']>;
  minScore?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
  queryString: Scalars['String'];
  type?: InputMaybe<Scalars['String']>;
};


export type QueryRootSeasonArgs = {
  id: Scalars['ID'];
};


export type QueryRootSectionArgs = {
  id: Scalars['ID'];
  timestamp?: InputMaybe<Scalars['String']>;
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

export type RedirectLink = {
  url: Scalars['String'];
};

export type RedirectParam = {
  key: Scalars['String'];
  value: Scalars['String'];
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
  ageRating: Scalars['String'];
  description: Scalars['String'];
  episodes: EpisodePagination;
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  imageUrl?: Maybe<Scalars['String']>;
  images: Array<Image>;
  legacyID?: Maybe<Scalars['ID']>;
  number: Scalars['Int'];
  show: Show;
  title: Scalars['String'];
};


export type SeasonEpisodesArgs = {
  dir?: InputMaybe<Scalars['String']>;
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};


export type SeasonImageArgs = {
  style?: InputMaybe<ImageStyle>;
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

export type SeasonItem = CollectionItem & {
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  images: Array<Image>;
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
  ageRating: Scalars['String'];
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
  title?: Maybe<Scalars['String']>;
};

export type SectionItem = {
  description: Scalars['String'];
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  item: SectionItemType;
  sort: Scalars['Int'];
  title: Scalars['String'];
};

export type SectionItemPagination = Pagination & {
  first: Scalars['Int'];
  items: Array<SectionItem>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export type SectionItemType = Episode | Link | Page | Season | Show;

export type SectionPagination = Pagination & {
  first: Scalars['Int'];
  items: Array<Section>;
  offset: Scalars['Int'];
  total: Scalars['Int'];
};

export enum SectionSize {
  Medium = 'medium',
  Small = 'small'
}

export type Settings = {
  audioLanguages: Array<Language>;
  subtitleLanguages: Array<Language>;
};

export type Show = {
  defaultEpisode: Episode;
  description: Scalars['String'];
  episodeCount: Scalars['Int'];
  id: Scalars['ID'];
  image?: Maybe<Scalars['String']>;
  imageUrl?: Maybe<Scalars['String']>;
  images: Array<Image>;
  legacyID?: Maybe<Scalars['ID']>;
  seasonCount: Scalars['Int'];
  seasons: SeasonPagination;
  title: Scalars['String'];
  type: ShowType;
};


export type ShowImageArgs = {
  style?: InputMaybe<ImageStyle>;
};


export type ShowSeasonsArgs = {
  dir?: InputMaybe<Scalars['String']>;
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

export type ShowItem = CollectionItem & {
  id: Scalars['ID'];
  imageUrl?: Maybe<Scalars['String']>;
  images: Array<Image>;
  show: Show;
  sort: Scalars['Int'];
  title: Scalars['String'];
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

export enum ShowType {
  Event = 'event',
  Series = 'series'
}

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
  Dash = 'dash',
  HlsCmaf = 'hls_cmaf',
  HlsTs = 'hls_ts'
}

export type User = {
  analytics: Analytics;
  anonymous: Scalars['Boolean'];
  audience?: Maybe<Scalars['String']>;
  bccMember: Scalars['Boolean'];
  email?: Maybe<Scalars['String']>;
  id?: Maybe<Scalars['ID']>;
  roles: Array<Scalars['String']>;
  settings: Settings;
};

export type WebSection = Section & {
  aspectRatio?: Maybe<Scalars['Float']>;
  authentication: Scalars['Boolean'];
  height?: Maybe<Scalars['Int']>;
  id: Scalars['ID'];
  metadata?: Maybe<ItemSectionMetadata>;
  title?: Maybe<Scalars['String']>;
  url: Scalars['String'];
  widthRatio: Scalars['Float'];
};

export type GetCalendarDayQueryVariables = Exact<{
  day: Scalars['Date'];
}>;


export type GetCalendarDayQuery = { calendar?: { day: { entries: Array<{ __typename: 'EpisodeCalendarEntry', id: string, title: string, description: string, end: any, start: any, episode?: { id: string, title: string, number?: number | null, publishDate: any, productionDate?: string | null, season?: { number: number, show: { id: string, type: ShowType, title: string } } | null } | null } | { __typename: 'SeasonCalendarEntry', id: string, title: string, description: string, end: any, start: any, season?: { id: string, number: number, title: string, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'ShowCalendarEntry', id: string, title: string, description: string, end: any, start: any, show?: { id: string, type: ShowType, title: string } | null } | { __typename: 'SimpleCalendarEntry', id: string, title: string, description: string, end: any, start: any }>, events: Array<{ id: string, title: string, start: string, end: string }> } } | null };

export type GetAnalyticsIdQueryVariables = Exact<{ [key: string]: never; }>;


export type GetAnalyticsIdQuery = { me: { analytics: { anonymousId: string } } };

export type GetSeasonOnEpisodePageQueryVariables = Exact<{
  seasonId: Scalars['ID'];
  firstEpisodes?: InputMaybe<Scalars['Int']>;
  offsetEpisodes?: InputMaybe<Scalars['Int']>;
}>;


export type GetSeasonOnEpisodePageQuery = { season: { id: string, title: string, image?: string | null, number: number, episodes: { total: number, items: Array<{ id: string, publishDate: any, number?: number | null, title: string, image?: string | null, progress?: number | null, duration: number, description: string, ageRating: string }> }, show: { id: string, title: string, description: string, type: ShowType, image?: string | null } } };

export type GetEpisodeQueryVariables = Exact<{
  episodeId: Scalars['ID'];
  context?: InputMaybe<EpisodeContext>;
}>;


export type GetEpisodeQuery = { episode: { id: string, title: string, description: string, image?: string | null, number?: number | null, progress?: number | null, ageRating: string, productionDate?: string | null, availableFrom: any, availableTo: any, publishDate: any, duration: number, context?: { __typename: 'ContextCollection', id: string, slug?: string | null, items?: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } | null } | { __typename: 'Season', id: string } | null, relatedItems?: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } | null, season?: { id: string, title: string, number: number, description: string, show: { title: string, type: ShowType, description: string, seasons: { items: Array<{ id: string, title: string, number: number }> } } } | null } };

export type UpdateEpisodeProgressMutationVariables = Exact<{
  episodeId: Scalars['ID'];
  progress?: InputMaybe<Scalars['Int']>;
  duration?: InputMaybe<Scalars['Int']>;
  context: EpisodeContext;
}>;


export type UpdateEpisodeProgressMutation = { setEpisodeProgress: { progress?: number | null } };

export type GetLiveCalendarRangeQueryVariables = Exact<{
  start: Scalars['Date'];
  end: Scalars['Date'];
}>;


export type GetLiveCalendarRangeQuery = { calendar?: { period: { activeDays: Array<any>, events: Array<{ title: string }> } } | null };

export type GetPageQueryVariables = Exact<{
  code: Scalars['String'];
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
}>;


export type GetPageQuery = { page: { id: string, title: string, sections: { total: number, offset: number, first: number, items: Array<{ __typename: 'DefaultGridSection', id: string, title?: string | null, gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'DefaultSection', id: string, title?: string | null, size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null } | { __typename: 'FeaturedSection', id: string, title?: string | null, size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null } | { __typename: 'IconGridSection', id: string, title?: string | null, gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'IconSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'LabelSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'ListSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'MessageSection', title?: string | null, id: string, messages?: Array<{ title: string, content: string, style: { text: string, background: string, border: string } }> | null } | { __typename: 'PosterGridSection', id: string, title?: string | null, gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'PosterSection', id: string, title?: string | null, size: SectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'WebSection', title?: string | null, url: string, height?: number | null, aspectRatio?: number | null, authentication: boolean, id: string }> } } };

export type GetSeasonQueryVariables = Exact<{
  id: Scalars['ID'];
}>;


export type GetSeasonQuery = { season: { title: string, description: string, imageUrl?: string | null, number: number, show: { title: string }, episodes: { total: number, items: Array<{ title: string, description: string, imageUrl?: string | null, number?: number | null }> } } };

export type SectionItemFragment = { id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } };


export type SectionItemFragmentVariables = Exact<{ [key: string]: never; }>;

type ItemSection_DefaultGridSection_Fragment = { gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } };

type ItemSection_DefaultSection_Fragment = { size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null };

type ItemSection_FeaturedSection_Fragment = { size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null };

type ItemSection_IconGridSection_Fragment = { gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } };

type ItemSection_IconSection_Fragment = { metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } };

type ItemSection_LabelSection_Fragment = { metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } };

type ItemSection_ListSection_Fragment = { metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } };

type ItemSection_PosterGridSection_Fragment = { gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } };

type ItemSection_PosterSection_Fragment = { size: SectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } };

export type ItemSectionFragment = ItemSection_DefaultGridSection_Fragment | ItemSection_DefaultSection_Fragment | ItemSection_FeaturedSection_Fragment | ItemSection_IconGridSection_Fragment | ItemSection_IconSection_Fragment | ItemSection_LabelSection_Fragment | ItemSection_ListSection_Fragment | ItemSection_PosterGridSection_Fragment | ItemSection_PosterSection_Fragment;


export type ItemSectionFragmentVariables = Exact<{ [key: string]: never; }>;

export type GetSectionQueryVariables = Exact<{
  id: Scalars['ID'];
  first: Scalars['Int'];
  offset: Scalars['Int'];
}>;


export type GetSectionQuery = { section: { __typename: 'DefaultGridSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'DefaultSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'FeaturedSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'IconGridSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'IconSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'LabelSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'ListSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'MessageSection', id: string } | { __typename: 'PosterGridSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'PosterSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate?: string | null, publishDate: any, progress?: number | null, duration: number, ageRating: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', id: string, code: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, defaultEpisode: { id: string }, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } }> } } | { __typename: 'WebSection', id: string } };

export type GetShowQueryVariables = Exact<{
  id: Scalars['ID'];
}>;


export type GetShowQuery = { show: { title: string, description: string, imageUrl?: string | null, seasons: { total: number, items: Array<{ title: string, description: string, imageUrl?: string | null, number: number, episodes: { total: number, items: Array<{ title: string, imageUrl?: string | null, number?: number | null, description: string }> } }> } } };

export type GetCalendarStatusQueryVariables = Exact<{
  day: Scalars['Date'];
}>;


export type GetCalendarStatusQuery = { calendar?: { day: { entries: Array<{ start: any, end: any } | { start: any, end: any } | { start: any, end: any } | { start: any, end: any }> } } | null };

export type ApplicationQueryVariables = Exact<{ [key: string]: never; }>;


export type ApplicationQuery = { application: { code: string, page?: { code: string } | null, searchPage?: { code: string } | null } };

export type GetCalendarPeriodQueryVariables = Exact<{
  from: Scalars['Date'];
  to: Scalars['Date'];
}>;


export type GetCalendarPeriodQuery = { calendar?: { period: { activeDays: Array<any>, events: Array<{ id: string, start: string, end: string, title: string }> } } | null };

export type GetRedirectUrlQueryVariables = Exact<{
  code: Scalars['String'];
}>;


export type GetRedirectUrlQuery = { redirect: { url: string } };

export type SearchQueryVariables = Exact<{
  query: Scalars['String'];
  type?: InputMaybe<Scalars['String']>;
  minScore?: InputMaybe<Scalars['Int']>;
}>;


export type SearchQuery = { search: { hits: number, page: number, result: Array<{ __typename: 'EpisodeSearchItem', seasonTitle?: string | null, showTitle?: string | null, id: string, header?: string | null, title: string, description?: string | null, image?: string | null } | { __typename: 'SeasonSearchItem', id: string, header?: string | null, title: string, description?: string | null, image?: string | null } | { __typename: 'ShowSearchItem', id: string, header?: string | null, title: string, description?: string | null, image?: string | null }> } };

export type GetDefaultEpisodeIdQueryVariables = Exact<{
  showId: Scalars['ID'];
}>;


export type GetDefaultEpisodeIdQuery = { show: { defaultEpisode: { id: string } } };

export const SectionItemFragmentDoc = gql`
    fragment SectionItem on SectionItem {
  id
  image
  title
  sort
  item {
    __typename
    ... on Episode {
      id
      episodeNumber: number
      productionDate
      publishDate
      progress
      duration
      ageRating
      season {
        id
        title
        number
        show {
          id
          type
          title
        }
      }
    }
    ... on Season {
      id
      seasonNumber: number
      show {
        title
      }
      episodes(first: 1, dir: "desc") {
        items {
          publishDate
        }
      }
    }
    ... on Show {
      id
      episodeCount
      seasonCount
      defaultEpisode {
        id
      }
      seasons(first: 1, dir: "desc") {
        items {
          episodes(first: 1, dir: "desc") {
            items {
              publishDate
            }
          }
        }
      }
    }
    ... on Page {
      id
      code
    }
  }
}
    `;
export const ItemSectionFragmentDoc = gql`
    fragment ItemSection on ItemSection {
  metadata {
    collectionId
    continueWatching
    useContext
    prependLiveElement
    secondaryTitles
  }
  items(first: $first, offset: $offset) {
    total
    first
    offset
    items {
      ...SectionItem
    }
  }
  ... on DefaultSection {
    size
    items(first: $first, offset: $offset) {
      items {
        description
      }
    }
  }
  ... on FeaturedSection {
    size
    items(first: $first, offset: $offset) {
      items {
        description
      }
    }
  }
  ... on GridSection {
    gridSize: size
  }
  ... on PosterSection {
    size
  }
}
    ${SectionItemFragmentDoc}`;
export const GetCalendarDayDocument = gql`
    query getCalendarDay($day: Date!) {
  calendar {
    day(day: $day) {
      entries {
        __typename
        id
        title
        description
        end
        start
        ... on EpisodeCalendarEntry {
          episode {
            id
            title
            number
            publishDate
            productionDate
            season {
              number
              show {
                id
                type
                title
              }
            }
          }
        }
        ... on SeasonCalendarEntry {
          season {
            id
            number
            title
            show {
              id
              type
              title
            }
          }
        }
        ... on ShowCalendarEntry {
          show {
            id
            type
            title
          }
        }
      }
      events {
        id
        title
        start
        end
      }
    }
  }
}
    `;

export function useGetCalendarDayQuery(options: Omit<Urql.UseQueryArgs<never, GetCalendarDayQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetCalendarDayQuery>({ query: GetCalendarDayDocument, ...options });
};
export const GetAnalyticsIdDocument = gql`
    query getAnalyticsID {
  me {
    analytics {
      anonymousId
    }
  }
}
    `;

export function useGetAnalyticsIdQuery(options: Omit<Urql.UseQueryArgs<never, GetAnalyticsIdQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetAnalyticsIdQuery>({ query: GetAnalyticsIdDocument, ...options });
};
export const GetSeasonOnEpisodePageDocument = gql`
    query getSeasonOnEpisodePage($seasonId: ID!, $firstEpisodes: Int, $offsetEpisodes: Int) {
  season(id: $seasonId) {
    id
    title
    image(style: default)
    number
    episodes(first: $firstEpisodes, offset: $offsetEpisodes) {
      total
      items {
        id
        publishDate
        number
        title
        image
        progress
        duration
        description
        ageRating
      }
    }
    show {
      id
      title
      description
      type
      image(style: default)
    }
  }
}
    `;

export function useGetSeasonOnEpisodePageQuery(options: Omit<Urql.UseQueryArgs<never, GetSeasonOnEpisodePageQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetSeasonOnEpisodePageQuery>({ query: GetSeasonOnEpisodePageDocument, ...options });
};
export const GetEpisodeDocument = gql`
    query getEpisode($episodeId: ID!, $context: EpisodeContext) {
  episode(id: $episodeId, context: $context) {
    id
    title
    description
    image(style: default)
    number
    progress
    ageRating
    productionDate
    availableFrom
    availableTo
    publishDate
    duration
    context {
      __typename
      ... on Season {
        id
      }
      ... on ContextCollection {
        id
        slug
        items {
          items {
            ...SectionItem
          }
        }
      }
    }
    relatedItems {
      items {
        ...SectionItem
      }
    }
    season {
      id
      title
      number
      description
      show {
        title
        type
        description
        seasons {
          items {
            id
            title
            number
          }
        }
      }
    }
  }
}
    ${SectionItemFragmentDoc}`;

export function useGetEpisodeQuery(options: Omit<Urql.UseQueryArgs<never, GetEpisodeQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetEpisodeQuery>({ query: GetEpisodeDocument, ...options });
};
export const UpdateEpisodeProgressDocument = gql`
    mutation updateEpisodeProgress($episodeId: ID!, $progress: Int, $duration: Int, $context: EpisodeContext!) {
  setEpisodeProgress(
    id: $episodeId
    progress: $progress
    duration: $duration
    context: $context
  ) {
    progress
  }
}
    `;

export function useUpdateEpisodeProgressMutation() {
  return Urql.useMutation<UpdateEpisodeProgressMutation, UpdateEpisodeProgressMutationVariables>(UpdateEpisodeProgressDocument);
};
export const GetLiveCalendarRangeDocument = gql`
    query getLiveCalendarRange($start: Date!, $end: Date!) {
  calendar {
    period(from: $start, to: $end) {
      events {
        title
      }
      activeDays
    }
  }
}
    `;

export function useGetLiveCalendarRangeQuery(options: Omit<Urql.UseQueryArgs<never, GetLiveCalendarRangeQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetLiveCalendarRangeQuery>({ query: GetLiveCalendarRangeDocument, ...options });
};
export const GetPageDocument = gql`
    query getPage($code: String!, $first: Int, $offset: Int) {
  page(code: $code) {
    id
    title
    sections(first: $first, offset: $offset) {
      total
      offset
      first
      items {
        __typename
        id
        title
        ...ItemSection
        ... on WebSection {
          title
          url
          height
          aspectRatio
          authentication
        }
        ... on MessageSection {
          title
          messages {
            title
            content
            style {
              text
              background
              border
            }
          }
        }
      }
    }
  }
}
    ${ItemSectionFragmentDoc}`;

export function useGetPageQuery(options: Omit<Urql.UseQueryArgs<never, GetPageQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetPageQuery>({ query: GetPageDocument, ...options });
};
export const GetSeasonDocument = gql`
    query getSeason($id: ID!) {
  season(id: $id) {
    title
    description
    imageUrl
    number
    show {
      title
    }
    episodes {
      total
      items {
        title
        description
        imageUrl
        number
      }
    }
  }
}
    `;

export function useGetSeasonQuery(options: Omit<Urql.UseQueryArgs<never, GetSeasonQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetSeasonQuery>({ query: GetSeasonDocument, ...options });
};
export const GetSectionDocument = gql`
    query getSection($id: ID!, $first: Int!, $offset: Int!) {
  section(id: $id) {
    __typename
    id
    ... on ItemSection {
      metadata {
        collectionId
        continueWatching
        useContext
        prependLiveElement
        secondaryTitles
      }
      items(first: $first, offset: $offset) {
        total
        first
        offset
        items {
          ...SectionItem
        }
      }
    }
  }
}
    ${SectionItemFragmentDoc}`;

export function useGetSectionQuery(options: Omit<Urql.UseQueryArgs<never, GetSectionQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetSectionQuery>({ query: GetSectionDocument, ...options });
};
export const GetShowDocument = gql`
    query getShow($id: ID!) {
  show(id: $id) {
    title
    description
    imageUrl
    seasons {
      total
      items {
        title
        description
        imageUrl
        description
        number
        episodes {
          total
          items {
            title
            imageUrl
            number
            description
          }
        }
      }
    }
  }
}
    `;

export function useGetShowQuery(options: Omit<Urql.UseQueryArgs<never, GetShowQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetShowQuery>({ query: GetShowDocument, ...options });
};
export const GetCalendarStatusDocument = gql`
    query getCalendarStatus($day: Date!) {
  calendar {
    day(day: $day) {
      entries {
        start
        end
      }
    }
  }
}
    `;

export function useGetCalendarStatusQuery(options: Omit<Urql.UseQueryArgs<never, GetCalendarStatusQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetCalendarStatusQuery>({ query: GetCalendarStatusDocument, ...options });
};
export const ApplicationDocument = gql`
    query application {
  application {
    code
    page {
      code
    }
    searchPage {
      code
    }
  }
}
    `;

export function useApplicationQuery(options: Omit<Urql.UseQueryArgs<never, ApplicationQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<ApplicationQuery>({ query: ApplicationDocument, ...options });
};
export const GetCalendarPeriodDocument = gql`
    query getCalendarPeriod($from: Date!, $to: Date!) {
  calendar {
    period(from: $from, to: $to) {
      activeDays
      events {
        id
        start
        end
        title
      }
    }
  }
}
    `;

export function useGetCalendarPeriodQuery(options: Omit<Urql.UseQueryArgs<never, GetCalendarPeriodQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetCalendarPeriodQuery>({ query: GetCalendarPeriodDocument, ...options });
};
export const GetRedirectUrlDocument = gql`
    query getRedirectUrl($code: String!) {
  redirect(id: $code) {
    url
  }
}
    `;

export function useGetRedirectUrlQuery(options: Omit<Urql.UseQueryArgs<never, GetRedirectUrlQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetRedirectUrlQuery>({ query: GetRedirectUrlDocument, ...options });
};
export const SearchDocument = gql`
    query search($query: String!, $type: String, $minScore: Int) {
  search(queryString: $query, type: $type, minScore: $minScore) {
    hits
    page
    result {
      __typename
      id
      header
      title
      description
      image
      ... on EpisodeSearchItem {
        seasonTitle
        showTitle
      }
    }
  }
}
    `;

export function useSearchQuery(options: Omit<Urql.UseQueryArgs<never, SearchQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<SearchQuery>({ query: SearchDocument, ...options });
};
export const GetDefaultEpisodeIdDocument = gql`
    query getDefaultEpisodeId($showId: ID!) {
  show(id: $showId) {
    defaultEpisode {
      id
    }
  }
}
    `;

export function useGetDefaultEpisodeIdQuery(options: Omit<Urql.UseQueryArgs<never, GetDefaultEpisodeIdQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetDefaultEpisodeIdQuery>({ query: GetDefaultEpisodeIdDocument, ...options });
};