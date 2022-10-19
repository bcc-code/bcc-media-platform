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

export type Application = {
  clientVersion: Scalars['String'];
  code: Scalars['String'];
  id: Scalars['ID'];
  page?: Maybe<Page>;
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

export type DefaultSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
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
  chapters: Array<Chapter>;
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
  season?: Maybe<Season>;
  streams: Array<Stream>;
  subtitleLanguages: Array<Language>;
  title: Scalars['String'];
};


export type EpisodeImageArgs = {
  style?: InputMaybe<ImageStyle>;
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

export type FeaturedSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
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

export type GridSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
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

export type IconSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
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
  title?: Maybe<Scalars['String']>;
};


export type ItemSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']>;
  offset?: InputMaybe<Scalars['Int']>;
};

export type LabelSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
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

export type Link = {
  id: Scalars['ID'];
  url: Scalars['String'];
};

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

export type MutationRoot = {
  setDevicePushToken?: Maybe<Device>;
};


export type MutationRootSetDevicePushTokenArgs = {
  token: Scalars['String'];
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

export type PosterSection = ItemSection & Section & {
  id: Scalars['ID'];
  items: SectionItemPagination;
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
  faq: Faq;
  me: User;
  messages: Messages;
  page: Page;
  profile: Profile;
  profiles: Array<Profile>;
  search: SearchResult;
  season: Season;
  section: Section;
  show: Show;
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
  item?: Maybe<SectionItemType>;
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
  defaultEpisode?: Maybe<Episode>;
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
  anonymous: Scalars['Boolean'];
  audience?: Maybe<Scalars['String']>;
  bccMember: Scalars['Boolean'];
  email?: Maybe<Scalars['String']>;
  id?: Maybe<Scalars['ID']>;
  roles: Array<Scalars['String']>;
  settings: Settings;
};

export type GetSeasonQueryVariables = Exact<{
  id: Scalars['ID'];
}>;


export type GetSeasonQuery = { season: { title: string, description: string, imageUrl?: string | null, number: number, show: { title: string }, episodes: { total: number, items: Array<{ title: string, description: string, imageUrl?: string | null, number?: number | null }> } } };

export type GetShowQueryVariables = Exact<{
  id: Scalars['ID'];
}>;


export type GetShowQuery = { show: { title: string, description: string, imageUrl?: string | null, seasons: { total: number, items: Array<{ title: string, description: string, imageUrl?: string | null, number: number, episodes: { total: number, items: Array<{ title: string, imageUrl?: string | null, number?: number | null, description: string }> } }> } } };

export type GetCalendarPeriodQueryVariables = Exact<{
  from: Scalars['Date'];
  to: Scalars['Date'];
}>;


export type GetCalendarPeriodQuery = { calendar?: { period: { activeDays: Array<any>, events: Array<{ id: string, start: string, end: string, title: string }> } } | null };

export type GetEpisodeQueryVariables = Exact<{
  episodeId: Scalars['ID'];
  firstEpisodes?: InputMaybe<Scalars['Int']>;
  offsetEpisodes?: InputMaybe<Scalars['Int']>;
}>;


export type GetEpisodeQuery = { episode: { id: string, title: string, description: string, imageUrl?: string | null, number?: number | null, season?: { id: string, title: string, imageUrl?: string | null, number: number, episodes: { total: number, items: Array<{ id: string, number?: number | null, title: string }> }, show: { id: string, title: string } } | null } };

export type SectionItemFragment = { id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null };


export type SectionItemFragmentVariables = Exact<{ [key: string]: never; }>;

type ItemSection_DefaultSection_Fragment = { size: SectionSize, items: { items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } };

type ItemSection_FeaturedSection_Fragment = { size: SectionSize, items: { items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } };

type ItemSection_GridSection_Fragment = { gridSize: GridSectionSize, items: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } };

type ItemSection_IconSection_Fragment = { items: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } };

type ItemSection_LabelSection_Fragment = { items: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } };

type ItemSection_PosterSection_Fragment = { size: SectionSize, items: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } };

export type ItemSectionFragment = ItemSection_DefaultSection_Fragment | ItemSection_FeaturedSection_Fragment | ItemSection_GridSection_Fragment | ItemSection_IconSection_Fragment | ItemSection_LabelSection_Fragment | ItemSection_PosterSection_Fragment;


export type ItemSectionFragmentVariables = Exact<{ [key: string]: never; }>;

export type GetPageQueryVariables = Exact<{
  code: Scalars['String'];
}>;


export type GetPageQuery = { page: { id: string, title: string, sections: { items: Array<{ __typename: 'DefaultSection', id: string, title?: string | null, size: SectionSize, items: { items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } } | { __typename: 'FeaturedSection', id: string, title?: string | null, size: SectionSize, items: { items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } } | { __typename: 'GridSection', id: string, title?: string | null, gridSize: GridSectionSize, items: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } } | { __typename: 'IconSection', id: string, title?: string | null, items: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } } | { __typename: 'LabelSection', id: string, title?: string | null, items: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } } | { __typename: 'PosterSection', id: string, title?: string | null, size: SectionSize, items: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item?: { __typename: 'Episode', episodeNumber?: number | null, season?: { number: number, show: { title: string } } | null } | { __typename: 'Link' } | { __typename: 'Page', code: string } | { __typename: 'Season', seasonNumber: number, show: { title: string } } | { __typename: 'Show', episodeCount: number, seasonCount: number, defaultEpisode?: { id: string } | null } | null }> } }> } } };

export type SearchQueryVariables = Exact<{
  query: Scalars['String'];
  type?: InputMaybe<Scalars['String']>;
  minScore?: InputMaybe<Scalars['Int']>;
}>;


export type SearchQuery = { search: { hits: number, page: number, result: Array<{ __typename: 'EpisodeSearchItem', id: string, header?: string | null, title: string, description?: string | null, image?: string | null } | { __typename: 'SeasonSearchItem', id: string, header?: string | null, title: string, description?: string | null, image?: string | null } | { __typename: 'ShowSearchItem', id: string, header?: string | null, title: string, description?: string | null, image?: string | null }> } };

export type GetDefaultEpisodeIdQueryVariables = Exact<{
  showId: Scalars['ID'];
}>;


export type GetDefaultEpisodeIdQuery = { show: { defaultEpisode?: { id: string } | null } };

export const SectionItemFragmentDoc = gql`
    fragment SectionItem on SectionItem {
  id
  image
  title
  sort
  item {
    __typename
    ... on Episode {
      episodeNumber: number
      season {
        number
        show {
          title
        }
      }
    }
    ... on Season {
      seasonNumber: number
      show {
        title
      }
    }
    ... on Show {
      episodeCount
      seasonCount
      defaultEpisode {
        id
      }
    }
    ... on Page {
      code
    }
  }
}
    `;
export const ItemSectionFragmentDoc = gql`
    fragment ItemSection on ItemSection {
  items {
    items {
      ...SectionItem
    }
  }
  ... on DefaultSection {
    size
    items {
      items {
        description
      }
    }
  }
  ... on FeaturedSection {
    size
    items {
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
export const GetEpisodeDocument = gql`
    query getEpisode($episodeId: ID!, $firstEpisodes: Int, $offsetEpisodes: Int) {
  episode(id: $episodeId) {
    id
    title
    description
    imageUrl
    number
    season {
      id
      title
      imageUrl
      number
      episodes(first: $firstEpisodes, offset: $offsetEpisodes) {
        total
        items {
          id
          number
          title
        }
      }
      show {
        id
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
        __typename
        id
        title
        ...ItemSection
      }
    }
  }
}
    ${ItemSectionFragmentDoc}`;

export function useGetPageQuery(options: Omit<Urql.UseQueryArgs<never, GetPageQueryVariables>, 'query'> = {}) {
  return Urql.useQuery<GetPageQuery>({ query: GetPageDocument, ...options });
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