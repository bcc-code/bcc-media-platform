import gql from 'graphql-tag';
import * as Urql from '@urql/vue';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
  Date: { input: any; output: any; }
  Language: { input: any; output: any; }
  UUID: { input: any; output: any; }
};

export type Achievement = {
  achieved: Scalars['Boolean']['output'];
  achievedAt?: Maybe<Scalars['Date']['output']>;
  description?: Maybe<Scalars['String']['output']>;
  group?: Maybe<AchievementGroup>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  title: Scalars['String']['output'];
};

export type AchievementGroup = {
  achievements: AchievementPagination;
  id: Scalars['ID']['output'];
  title: Scalars['String']['output'];
};


export type AchievementGroupAchievementsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type AchievementGroupPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<AchievementGroup>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type AchievementPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<Achievement>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type AchievementSection = Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  title?: Maybe<Scalars['String']['output']>;
};

export type AddToCollectionResult = {
  collection: UserCollection;
  entryId: Scalars['UUID']['output'];
};

export type Alternative = {
  id: Scalars['ID']['output'];
  isCorrect?: Maybe<Scalars['Boolean']['output']>;
  selected: Scalars['Boolean']['output'];
  title: Scalars['String']['output'];
};

export type AlternativesTask = Task & {
  alternatives: Array<Alternative>;
  competitionMode: Scalars['Boolean']['output'];
  completed: Scalars['Boolean']['output'];
  id: Scalars['ID']['output'];
  locked: Scalars['Boolean']['output'];
  title: Scalars['String']['output'];
};

export type Analytics = {
  anonymousId: Scalars['String']['output'];
};

export type AnswerSurveyQuestionResult = {
  id: Scalars['String']['output'];
};

export type Application = {
  clientVersion: Scalars['String']['output'];
  code: Scalars['String']['output'];
  gamesPage?: Maybe<Page>;
  id: Scalars['ID']['output'];
  livestreamEnabled: Scalars['Boolean']['output'];
  page?: Maybe<Page>;
  searchPage?: Maybe<Page>;
};

export type AvatarSection = ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: SectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type AvatarSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type BirthOptions = {
  year: Scalars['Int']['input'];
};

export type Calendar = {
  day: CalendarDay;
  events: Array<Event>;
  period: CalendarPeriod;
};


export type CalendarDayArgs = {
  day: Scalars['Date']['input'];
};


export type CalendarEventsArgs = {
  from?: InputMaybe<Scalars['Date']['input']>;
  to?: InputMaybe<Scalars['Date']['input']>;
};


export type CalendarPeriodArgs = {
  from: Scalars['Date']['input'];
  to: Scalars['Date']['input'];
};

export type CalendarDay = {
  entries: Array<CalendarEntry>;
  events: Array<Event>;
};

export type CalendarEntry = {
  description: Scalars['String']['output'];
  end: Scalars['Date']['output'];
  event?: Maybe<Event>;
  id: Scalars['ID']['output'];
  start: Scalars['Date']['output'];
  title: Scalars['String']['output'];
};

export type CalendarPeriod = {
  activeDays: Array<Scalars['Date']['output']>;
  events: Array<Event>;
};

export type CardListSection = ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: CardSectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type CardListSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type CardSection = ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: CardSectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type CardSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export enum CardSectionSize {
  Large = 'large',
  Mini = 'mini'
}

export type Chapter = CollectionItem & {
  contentType: ContentType;
  description?: Maybe<Scalars['String']['output']>;
  duration: Scalars['Int']['output'];
  episode?: Maybe<Episode>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  start: Scalars['Int']['output'];
  title: Scalars['String']['output'];
};

export type CollectionItem = {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  title: Scalars['String']['output'];
};

export type Config = {
  global: GlobalConfig;
};


export type ConfigGlobalArgs = {
  timestamp?: InputMaybe<Scalars['String']['input']>;
};

export type ConfirmAchievementResult = {
  success: Scalars['Boolean']['output'];
};

export type ContentType = {
  code: Scalars['String']['output'];
  title: Scalars['String']['output'];
};

export type ContentTypeCount = {
  count: Scalars['Int']['output'];
  type: ContentType;
};

export type ContextCollection = {
  id: Scalars['ID']['output'];
  items?: Maybe<SectionItemPagination>;
  slug?: Maybe<Scalars['String']['output']>;
};


export type ContextCollectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type Contribution = {
  contentType: ContentType;
  item: ContributionItem;
  type: ContributionType;
};

export type ContributionItem = Chapter | Episode;

export type ContributionType = {
  code: Scalars['String']['output'];
  title: Scalars['String']['output'];
};

export type ContributionTypeCount = {
  count: Scalars['Int']['output'];
  type: ContributionType;
};

export type ContributionsPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<Contribution>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type DefaultGridSection = GridSection & ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: GridSectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type DefaultGridSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type DefaultSection = ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: SectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type DefaultSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type Device = {
  token: Scalars['String']['output'];
  updatedAt: Scalars['Date']['output'];
};

export type EmailOptions = {
  email: Scalars['String']['input'];
  name: Scalars['String']['input'];
};

export type Episode = CollectionItem & MediaItem & PlaylistItem & {
  ageRating: Scalars['String']['output'];
  assetVersion: Scalars['String']['output'];
  audioLanguages: Array<Scalars['Language']['output']>;
  availableFrom: Scalars['Date']['output'];
  availableTo: Scalars['Date']['output'];
  chapters: Array<Chapter>;
  context?: Maybe<EpisodeContextUnion>;
  cursor: Scalars['String']['output'];
  description: Scalars['String']['output'];
  duration: Scalars['Int']['output'];
  extraDescription: Scalars['String']['output'];
  files: Array<File>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  /** @deprecated Replaced by the image field */
  imageUrl?: Maybe<Scalars['String']['output']>;
  images: Array<Image>;
  inMyList: Scalars['Boolean']['output'];
  legacyID?: Maybe<Scalars['ID']['output']>;
  legacyProgramID?: Maybe<Scalars['ID']['output']>;
  lessons: LessonPagination;
  locked: Scalars['Boolean']['output'];
  /** Should probably be used asynchronously, and retrieved separately from the episode, as it can be slow in some cases (a few db requests can occur) */
  next: Array<Episode>;
  number?: Maybe<Scalars['Int']['output']>;
  originalTitle: Scalars['String']['output'];
  productionDate: Scalars['Date']['output'];
  productionDateInTitle: Scalars['Boolean']['output'];
  progress?: Maybe<Scalars['Int']['output']>;
  publishDate: Scalars['Date']['output'];
  relatedItems?: Maybe<SectionItemPagination>;
  season?: Maybe<Season>;
  shareRestriction: ShareRestriction;
  skipToChapter?: Maybe<Chapter>;
  status: Status;
  streams: Array<Stream>;
  subtitleLanguages: Array<Scalars['Language']['output']>;
  title: Scalars['String']['output'];
  type: EpisodeType;
  uuid: Scalars['String']['output'];
  watched: Scalars['Boolean']['output'];
};


export type EpisodeFilesArgs = {
  audioLanguages?: InputMaybe<Array<Scalars['String']['input']>>;
};


export type EpisodeImageArgs = {
  style?: InputMaybe<ImageStyle>;
};


export type EpisodeLessonsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type EpisodeNextArgs = {
  limit?: InputMaybe<Scalars['Int']['input']>;
};


export type EpisodeRelatedItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type EpisodeCalendarEntry = CalendarEntry & {
  description: Scalars['String']['output'];
  end: Scalars['Date']['output'];
  episode?: Maybe<Episode>;
  event?: Maybe<Event>;
  id: Scalars['ID']['output'];
  isReplay: Scalars['Boolean']['output'];
  start: Scalars['Date']['output'];
  title: Scalars['String']['output'];
};

export type EpisodeContext = {
  collectionId?: InputMaybe<Scalars['String']['input']>;
  cursor?: InputMaybe<Scalars['String']['input']>;
  playlistId?: InputMaybe<Scalars['String']['input']>;
  shuffle?: InputMaybe<Scalars['Boolean']['input']>;
};

export type EpisodeContextUnion = ContextCollection | Season;

export type EpisodePagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<Episode>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type EpisodeSearchItem = SearchResultItem & {
  ageRating: Scalars['String']['output'];
  collection: Scalars['String']['output'];
  description?: Maybe<Scalars['String']['output']>;
  duration: Scalars['Int']['output'];
  header?: Maybe<Scalars['String']['output']>;
  highlight?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  legacyID?: Maybe<Scalars['ID']['output']>;
  legacyProgramID?: Maybe<Scalars['ID']['output']>;
  season?: Maybe<Season>;
  seasonId?: Maybe<Scalars['ID']['output']>;
  seasonTitle?: Maybe<Scalars['String']['output']>;
  show?: Maybe<Show>;
  showId?: Maybe<Scalars['ID']['output']>;
  showTitle?: Maybe<Scalars['String']['output']>;
  title: Scalars['String']['output'];
  url: Scalars['String']['output'];
};

export enum EpisodeType {
  Episode = 'episode',
  Standalone = 'standalone'
}

export type Event = {
  end: Scalars['String']['output'];
  entries: Array<CalendarEntry>;
  id: Scalars['ID']['output'];
  image: Scalars['String']['output'];
  start: Scalars['String']['output'];
  title: Scalars['String']['output'];
};

export type Export = {
  dbVersion: Scalars['String']['output'];
  url: Scalars['String']['output'];
};

export type Faq = {
  categories?: Maybe<FaqCategoryPagination>;
  category: FaqCategory;
  question: Question;
};


export type FaqCategoriesArgs = {
  Offset?: InputMaybe<Scalars['Int']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
};


export type FaqCategoryArgs = {
  id: Scalars['ID']['input'];
};


export type FaqQuestionArgs = {
  id: Scalars['ID']['input'];
};

export type FaqCategory = {
  id: Scalars['ID']['output'];
  questions?: Maybe<QuestionPagination>;
  title: Scalars['String']['output'];
};


export type FaqCategoryQuestionsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type FaqCategoryPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<FaqCategory>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type FeaturedSection = ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: SectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type FeaturedSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type File = {
  audioLanguage: Scalars['Language']['output'];
  fileName: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  mimeType: Scalars['String']['output'];
  resolution?: Maybe<Scalars['String']['output']>;
  size: Scalars['Int']['output'];
  subtitleLanguage?: Maybe<Scalars['Language']['output']>;
  url: Scalars['String']['output'];
  videoLanguage?: Maybe<Scalars['Language']['output']>;
};

export type Game = CollectionItem & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  title: Scalars['String']['output'];
  url: Scalars['String']['output'];
};


export type GameImageArgs = {
  style?: InputMaybe<ImageStyle>;
};

export enum Gender {
  Female = 'female',
  Male = 'male',
  Unknown = 'unknown'
}

export type GlobalConfig = {
  liveOnline: Scalars['Boolean']['output'];
  npawEnabled: Scalars['Boolean']['output'];
};

export type GridSection = {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: GridSectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type GridSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export enum GridSectionSize {
  Half = 'half'
}

export type IconGridSection = GridSection & ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: GridSectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type IconGridSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type IconSection = ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  title?: Maybe<Scalars['String']['output']>;
};


export type IconSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type Image = {
  style: Scalars['String']['output'];
  url: Scalars['String']['output'];
};

export enum ImageStyle {
  Default = 'default',
  Featured = 'featured',
  Poster = 'poster'
}

export type ItemSection = {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  title?: Maybe<Scalars['String']['output']>;
};


export type ItemSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type ItemSectionMetadata = {
  collectionId: Scalars['ID']['output'];
  continueWatching: Scalars['Boolean']['output'];
  limit?: Maybe<Scalars['Int']['output']>;
  myList: Scalars['Boolean']['output'];
  page?: Maybe<Page>;
  prependLiveElement: Scalars['Boolean']['output'];
  secondaryTitles: Scalars['Boolean']['output'];
  useContext: Scalars['Boolean']['output'];
};

export type LabelSection = ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  title?: Maybe<Scalars['String']['output']>;
};


export type LabelSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type LegacyIdLookup = {
  id: Scalars['ID']['output'];
};

export type LegacyIdLookupOptions = {
  episodeID?: InputMaybe<Scalars['Int']['input']>;
  programID?: InputMaybe<Scalars['Int']['input']>;
};

export type Lesson = {
  completed: Scalars['Boolean']['output'];
  /**
   * The default episode.
   * Should not be used actively in lists, as it could affect query speeds.
   */
  defaultEpisode?: Maybe<Episode>;
  description: Scalars['String']['output'];
  episodes: EpisodePagination;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  links: LinkPagination;
  locked: Scalars['Boolean']['output'];
  next?: Maybe<Lesson>;
  previous?: Maybe<Lesson>;
  progress: TasksProgress;
  tasks: TaskPagination;
  title: Scalars['String']['output'];
  topic: StudyTopic;
};


export type LessonEpisodesArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type LessonImageArgs = {
  style?: InputMaybe<ImageStyle>;
};


export type LessonLinksArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type LessonTasksArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type LessonPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<Lesson>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type LessonsProgress = {
  completed: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type Link = {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  title: Scalars['String']['output'];
  type: LinkType;
  url: Scalars['String']['output'];
};


export type LinkImageArgs = {
  style?: InputMaybe<ImageStyle>;
};

export type LinkPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<Link>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type LinkTask = Task & {
  completed: Scalars['Boolean']['output'];
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  link: Link;
  secondaryTitle?: Maybe<Scalars['String']['output']>;
  title: Scalars['String']['output'];
};

export enum LinkType {
  Audio = 'audio',
  Other = 'other',
  Text = 'text',
  Video = 'video'
}

export type ListSection = ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: SectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type ListSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type MediaItem = {
  files: Array<File>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  originalTitle: Scalars['String']['output'];
  streams: Array<Stream>;
  title: Scalars['String']['output'];
};


export type MediaItemImageArgs = {
  style?: InputMaybe<ImageStyle>;
};

export type Message = {
  content: Scalars['String']['output'];
  style: MessageStyle;
  title: Scalars['String']['output'];
};

export type MessageSection = Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  messages?: Maybe<Array<Message>>;
  title?: Maybe<Scalars['String']['output']>;
};

export type MessageStyle = {
  background: Scalars['String']['output'];
  border: Scalars['String']['output'];
  text: Scalars['String']['output'];
};

export type MutationRoot = {
  addEpisodeToMyList: AddToCollectionResult;
  addShortToMyList: AddToCollectionResult;
  addShowToMyList: AddToCollectionResult;
  answerSurveyQuestion: AnswerSurveyQuestionResult;
  completeTask: Scalars['Boolean']['output'];
  confirmAchievement: ConfirmAchievementResult;
  lockLessonAnswers: Scalars['Boolean']['output'];
  removeEntryFromMyList: UserCollection;
  sendEpisodeFeedback: Scalars['ID']['output'];
  sendSupportEmail: Scalars['Boolean']['output'];
  sendTaskMessage: Scalars['ID']['output'];
  sendVerificationEmail: Scalars['Boolean']['output'];
  setDevicePushToken?: Maybe<Device>;
  setEpisodeProgress: Episode;
  setShortProgress: Short;
  subscribe: Scalars['Boolean']['output'];
  unsubscribe: Scalars['Boolean']['output'];
  updateEpisodeFeedback: Scalars['ID']['output'];
  updateSurveyQuestionAnswer: AnswerSurveyQuestionResult;
  updateTaskMessage: Scalars['ID']['output'];
  updateUserMetadata: Scalars['Boolean']['output'];
};


export type MutationRootAddEpisodeToMyListArgs = {
  episodeId: Scalars['ID']['input'];
};


export type MutationRootAddShortToMyListArgs = {
  shortId: Scalars['ID']['input'];
};


export type MutationRootAddShowToMyListArgs = {
  showId: Scalars['ID']['input'];
};


export type MutationRootAnswerSurveyQuestionArgs = {
  answer: Scalars['String']['input'];
  id: Scalars['UUID']['input'];
};


export type MutationRootCompleteTaskArgs = {
  id: Scalars['ID']['input'];
  selectedAlternatives?: InputMaybe<Array<Scalars['String']['input']>>;
};


export type MutationRootConfirmAchievementArgs = {
  id: Scalars['ID']['input'];
};


export type MutationRootLockLessonAnswersArgs = {
  id: Scalars['ID']['input'];
};


export type MutationRootRemoveEntryFromMyListArgs = {
  entryId: Scalars['UUID']['input'];
};


export type MutationRootSendEpisodeFeedbackArgs = {
  episodeId: Scalars['ID']['input'];
  message?: InputMaybe<Scalars['String']['input']>;
  rating?: InputMaybe<Scalars['Int']['input']>;
};


export type MutationRootSendSupportEmailArgs = {
  content: Scalars['String']['input'];
  html: Scalars['String']['input'];
  options?: InputMaybe<EmailOptions>;
  title: Scalars['String']['input'];
};


export type MutationRootSendTaskMessageArgs = {
  message?: InputMaybe<Scalars['String']['input']>;
  taskId: Scalars['ID']['input'];
};


export type MutationRootSetDevicePushTokenArgs = {
  languages: Array<Scalars['String']['input']>;
  token: Scalars['String']['input'];
};


export type MutationRootSetEpisodeProgressArgs = {
  context?: InputMaybe<EpisodeContext>;
  duration?: InputMaybe<Scalars['Int']['input']>;
  id: Scalars['ID']['input'];
  progress?: InputMaybe<Scalars['Int']['input']>;
};


export type MutationRootSetShortProgressArgs = {
  duration?: InputMaybe<Scalars['Float']['input']>;
  id: Scalars['UUID']['input'];
  progress?: InputMaybe<Scalars['Float']['input']>;
};


export type MutationRootSubscribeArgs = {
  topic: SubscriptionTopic;
};


export type MutationRootUnsubscribeArgs = {
  topic: SubscriptionTopic;
};


export type MutationRootUpdateEpisodeFeedbackArgs = {
  id: Scalars['ID']['input'];
  message?: InputMaybe<Scalars['String']['input']>;
  rating?: InputMaybe<Scalars['Int']['input']>;
};


export type MutationRootUpdateSurveyQuestionAnswerArgs = {
  answer: Scalars['String']['input'];
  key: Scalars['String']['input'];
};


export type MutationRootUpdateTaskMessageArgs = {
  id: Scalars['ID']['input'];
  message: Scalars['String']['input'];
};


export type MutationRootUpdateUserMetadataArgs = {
  birthData: BirthOptions;
  nameData: NameOptions;
};

export type NameOptions = {
  first: Scalars['String']['input'];
  last: Scalars['String']['input'];
};

export type Page = {
  code: Scalars['String']['output'];
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  images: Array<Image>;
  sections: SectionPagination;
  title: Scalars['String']['output'];
};


export type PageImageArgs = {
  style?: InputMaybe<ImageStyle>;
};


export type PageSectionsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type PageDetailsSection = Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  title?: Maybe<Scalars['String']['output']>;
};

export type Pagination = {
  first: Scalars['Int']['output'];
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type Person = {
  contributionContentTypes: Array<ContentTypeCount>;
  contributionTypes: Array<ContributionTypeCount>;
  contributions: ContributionsPagination;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  name: Scalars['String']['output'];
};


export type PersonContributionsArgs = {
  contentTypes?: InputMaybe<Array<Scalars['String']['input']>>;
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  shuffle?: InputMaybe<Scalars['Boolean']['input']>;
  types?: InputMaybe<Array<Scalars['String']['input']>>;
};


export type PersonImageArgs = {
  style?: InputMaybe<ImageStyle>;
};

export type Playlist = CollectionItem & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  items: PlaylistItemPagination;
  title: Scalars['String']['output'];
};


export type PlaylistImageArgs = {
  style?: InputMaybe<ImageStyle>;
};


export type PlaylistItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type PlaylistItem = {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  title: Scalars['String']['output'];
};


export type PlaylistItemImageArgs = {
  style?: InputMaybe<ImageStyle>;
};

export type PlaylistItemPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<PlaylistItem>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type PosterGridSection = GridSection & ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: GridSectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type PosterGridSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type PosterSection = ItemSection & Section & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  items: SectionItemPagination;
  metadata?: Maybe<ItemSectionMetadata>;
  size: SectionSize;
  title?: Maybe<Scalars['String']['output']>;
};


export type PosterSectionItemsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type PosterTask = Task & {
  completed: Scalars['Boolean']['output'];
  id: Scalars['ID']['output'];
  image: Scalars['String']['output'];
  title: Scalars['String']['output'];
};

export type Profile = {
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
};

export type Prompt = {
  from: Scalars['Date']['output'];
  id: Scalars['UUID']['output'];
  secondaryTitle?: Maybe<Scalars['String']['output']>;
  title: Scalars['String']['output'];
  to: Scalars['Date']['output'];
};

export type QueryRoot = {
  achievement: Achievement;
  achievementGroup: AchievementGroup;
  achievementGroups: AchievementGroupPagination;
  application: Application;
  calendar?: Maybe<Calendar>;
  config: Config;
  episode: Episode;
  episodes: Array<Episode>;
  event?: Maybe<Event>;
  export: Export;
  faq: Faq;
  game: Game;
  languages: Array<Scalars['Language']['output']>;
  legacyIDLookup: LegacyIdLookup;
  me: User;
  myList: UserCollection;
  page: Page;
  pendingAchievements: Array<Achievement>;
  person: Person;
  playlist: Playlist;
  profile: Profile;
  profiles: Array<Profile>;
  prompts: Array<Prompt>;
  redirect: RedirectLink;
  search: SearchResult;
  season: Season;
  section: Section;
  short: Short;
  shorts: ShortsPagination;
  show: Show;
  studyLesson: Lesson;
  studyTopic: StudyTopic;
  subscriptions: Array<SubscriptionTopic>;
  userCollection: UserCollection;
};


export type QueryRootAchievementArgs = {
  id: Scalars['ID']['input'];
};


export type QueryRootAchievementGroupArgs = {
  id: Scalars['ID']['input'];
};


export type QueryRootAchievementGroupsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type QueryRootApplicationArgs = {
  timestamp?: InputMaybe<Scalars['String']['input']>;
};


export type QueryRootEpisodeArgs = {
  context?: InputMaybe<EpisodeContext>;
  id: Scalars['ID']['input'];
};


export type QueryRootEpisodesArgs = {
  ids: Array<Scalars['ID']['input']>;
};


export type QueryRootEventArgs = {
  id: Scalars['ID']['input'];
};


export type QueryRootExportArgs = {
  groups?: InputMaybe<Array<Scalars['String']['input']>>;
};


export type QueryRootGameArgs = {
  id: Scalars['UUID']['input'];
};


export type QueryRootLegacyIdLookupArgs = {
  options?: InputMaybe<LegacyIdLookupOptions>;
};


export type QueryRootPageArgs = {
  code?: InputMaybe<Scalars['String']['input']>;
  id?: InputMaybe<Scalars['ID']['input']>;
};


export type QueryRootPersonArgs = {
  id: Scalars['ID']['input'];
};


export type QueryRootPlaylistArgs = {
  id: Scalars['ID']['input'];
};


export type QueryRootPromptsArgs = {
  timestamp?: InputMaybe<Scalars['Date']['input']>;
};


export type QueryRootRedirectArgs = {
  id: Scalars['String']['input'];
};


export type QueryRootSearchArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  minScore?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  queryString: Scalars['String']['input'];
  type?: InputMaybe<Scalars['String']['input']>;
};


export type QueryRootSeasonArgs = {
  id: Scalars['ID']['input'];
};


export type QueryRootSectionArgs = {
  id: Scalars['ID']['input'];
  timestamp?: InputMaybe<Scalars['String']['input']>;
};


export type QueryRootShortArgs = {
  id: Scalars['UUID']['input'];
};


export type QueryRootShortsArgs = {
  cursor?: InputMaybe<Scalars['String']['input']>;
  initialShortId?: InputMaybe<Scalars['UUID']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
};


export type QueryRootShowArgs = {
  id: Scalars['ID']['input'];
};


export type QueryRootStudyLessonArgs = {
  id: Scalars['ID']['input'];
};


export type QueryRootStudyTopicArgs = {
  id: Scalars['ID']['input'];
};


export type QueryRootUserCollectionArgs = {
  id: Scalars['UUID']['input'];
};

export type Question = {
  answer: Scalars['String']['output'];
  category: FaqCategory;
  id: Scalars['ID']['output'];
  question: Scalars['String']['output'];
};

export type QuestionPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<Question>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type QuoteTask = Task & {
  completed: Scalars['Boolean']['output'];
  id: Scalars['ID']['output'];
  image: Scalars['String']['output'];
  title: Scalars['String']['output'];
};

export type RedirectLink = {
  requiresAuthentication: Scalars['Boolean']['output'];
  url: Scalars['String']['output'];
};

export type RedirectParam = {
  key: Scalars['String']['output'];
  value: Scalars['String']['output'];
};

export type SearchResult = {
  hits: Scalars['Int']['output'];
  page: Scalars['Int']['output'];
  result: Array<SearchResultItem>;
};

export type SearchResultItem = {
  collection: Scalars['String']['output'];
  description?: Maybe<Scalars['String']['output']>;
  header?: Maybe<Scalars['String']['output']>;
  highlight?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  legacyID?: Maybe<Scalars['ID']['output']>;
  title: Scalars['String']['output'];
  url: Scalars['String']['output'];
};

export type Season = CollectionItem & {
  ageRating: Scalars['String']['output'];
  /**
   * The default episode.
   * Should not be used actively in lists, as it could affect query speeds.
   */
  defaultEpisode: Episode;
  description: Scalars['String']['output'];
  episodes: EpisodePagination;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  /** @deprecated Replaced by the image field */
  imageUrl?: Maybe<Scalars['String']['output']>;
  images: Array<Image>;
  legacyID?: Maybe<Scalars['ID']['output']>;
  number: Scalars['Int']['output'];
  show: Show;
  status: Status;
  title: Scalars['String']['output'];
};


export type SeasonEpisodesArgs = {
  dir?: InputMaybe<Scalars['String']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type SeasonImageArgs = {
  style?: InputMaybe<ImageStyle>;
};

export type SeasonCalendarEntry = CalendarEntry & {
  description: Scalars['String']['output'];
  end: Scalars['Date']['output'];
  event?: Maybe<Event>;
  id: Scalars['ID']['output'];
  season?: Maybe<Season>;
  start: Scalars['Date']['output'];
  title: Scalars['String']['output'];
};

export type SeasonPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<Season>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type SeasonSearchItem = SearchResultItem & {
  ageRating: Scalars['String']['output'];
  collection: Scalars['String']['output'];
  description?: Maybe<Scalars['String']['output']>;
  header?: Maybe<Scalars['String']['output']>;
  highlight?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  legacyID?: Maybe<Scalars['ID']['output']>;
  show: Show;
  showId: Scalars['ID']['output'];
  showTitle: Scalars['String']['output'];
  title: Scalars['String']['output'];
  url: Scalars['String']['output'];
};

export type Section = {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  title?: Maybe<Scalars['String']['output']>;
};

export type SectionItem = {
  description: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  item: SectionItemType;
  sort: Scalars['Int']['output'];
  title: Scalars['String']['output'];
};

export type SectionItemPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<SectionItem>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type SectionItemType = Episode | Game | Link | Page | Person | Playlist | Season | Short | Show | StudyTopic;

export type SectionPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<Section>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export enum SectionSize {
  Medium = 'medium',
  Small = 'small'
}

export enum ShareRestriction {
  Members = 'members',
  Public = 'public',
  Registered = 'registered'
}

export type Short = CollectionItem & MediaItem & PlaylistItem & {
  description?: Maybe<Scalars['String']['output']>;
  files: Array<File>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  inMyList: Scalars['Boolean']['output'];
  originalTitle: Scalars['String']['output'];
  source?: Maybe<SubclipSource>;
  streams: Array<Stream>;
  title: Scalars['String']['output'];
};


export type ShortImageArgs = {
  style?: InputMaybe<ImageStyle>;
};

export type ShortsPagination = {
  cursor: Scalars['String']['output'];
  nextCursor: Scalars['String']['output'];
  shorts: Array<Short>;
};

export type Show = CollectionItem & {
  /**
   * The default episode.
   * Should not be used actively in lists, as it could affect query speeds.
   */
  defaultEpisode: Episode;
  description: Scalars['String']['output'];
  episodeCount: Scalars['Int']['output'];
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  /** @deprecated Replaced by the image field */
  imageUrl?: Maybe<Scalars['String']['output']>;
  images: Array<Image>;
  legacyID?: Maybe<Scalars['ID']['output']>;
  seasonCount: Scalars['Int']['output'];
  seasons: SeasonPagination;
  status: Status;
  title: Scalars['String']['output'];
  type: ShowType;
};


export type ShowImageArgs = {
  style?: InputMaybe<ImageStyle>;
};


export type ShowSeasonsArgs = {
  dir?: InputMaybe<Scalars['String']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type ShowCalendarEntry = CalendarEntry & {
  description: Scalars['String']['output'];
  end: Scalars['Date']['output'];
  event?: Maybe<Event>;
  id: Scalars['ID']['output'];
  show?: Maybe<Show>;
  start: Scalars['Date']['output'];
  title: Scalars['String']['output'];
};

export type ShowSearchItem = SearchResultItem & {
  collection: Scalars['String']['output'];
  description?: Maybe<Scalars['String']['output']>;
  header?: Maybe<Scalars['String']['output']>;
  highlight?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  legacyID?: Maybe<Scalars['ID']['output']>;
  show: Show;
  title: Scalars['String']['output'];
  url: Scalars['String']['output'];
};

export enum ShowType {
  Event = 'event',
  Series = 'series'
}

export type SimpleCalendarEntry = CalendarEntry & {
  description: Scalars['String']['output'];
  end: Scalars['Date']['output'];
  event?: Maybe<Event>;
  id: Scalars['ID']['output'];
  start: Scalars['Date']['output'];
  title: Scalars['String']['output'];
};

export enum Status {
  Published = 'published',
  Unlisted = 'unlisted'
}

export type Stream = {
  audioLanguages: Array<Scalars['Language']['output']>;
  downloadable: Scalars['Boolean']['output'];
  expiresAt: Scalars['Date']['output'];
  id: Scalars['ID']['output'];
  subtitleLanguages: Array<Scalars['Language']['output']>;
  type: StreamType;
  url: Scalars['String']['output'];
  videoLanguage?: Maybe<Scalars['Language']['output']>;
};

export enum StreamType {
  Dash = 'dash',
  HlsCmaf = 'hls_cmaf',
  HlsTs = 'hls_ts'
}

export type StudyTopic = CollectionItem & {
  /**
   * The default lesson.
   * Should not be used actively in lists, as it could affect query speeds.
   */
  defaultLesson: Lesson;
  description: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  image?: Maybe<Scalars['String']['output']>;
  images: Array<Image>;
  lessons: LessonPagination;
  progress: LessonsProgress;
  title: Scalars['String']['output'];
};


export type StudyTopicImageArgs = {
  style?: InputMaybe<ImageStyle>;
};


export type StudyTopicLessonsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type SubclipSource = {
  end?: Maybe<Scalars['Float']['output']>;
  item: SubclipSourceItem;
  start?: Maybe<Scalars['Float']['output']>;
};

export type SubclipSourceItem = Episode;

export enum SubscriptionTopic {
  Comics = 'comics'
}

export type Survey = {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['UUID']['output'];
  questions: SurveyQuestionPagination;
  title: Scalars['String']['output'];
};


export type SurveyQuestionsArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type SurveyPrompt = Prompt & {
  from: Scalars['Date']['output'];
  id: Scalars['UUID']['output'];
  secondaryTitle?: Maybe<Scalars['String']['output']>;
  survey: Survey;
  title: Scalars['String']['output'];
  to: Scalars['Date']['output'];
};

export type SurveyQuestion = {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['UUID']['output'];
  title: Scalars['String']['output'];
};

export type SurveyQuestionPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<SurveyQuestion>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type SurveyRatingQuestion = SurveyQuestion & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['UUID']['output'];
  title: Scalars['String']['output'];
};

export type SurveyTextQuestion = SurveyQuestion & {
  description?: Maybe<Scalars['String']['output']>;
  id: Scalars['UUID']['output'];
  title: Scalars['String']['output'];
};

export type Task = {
  completed: Scalars['Boolean']['output'];
  id: Scalars['ID']['output'];
  title: Scalars['String']['output'];
};

export type TaskPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<Task>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type TasksProgress = {
  completed: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type TextTask = Task & {
  completed: Scalars['Boolean']['output'];
  id: Scalars['ID']['output'];
  title: Scalars['String']['output'];
};

export type User = {
  analytics: Analytics;
  anonymous: Scalars['Boolean']['output'];
  audience?: Maybe<Scalars['String']['output']>;
  bccMember: Scalars['Boolean']['output'];
  completedRegistration: Scalars['Boolean']['output'];
  displayName: Scalars['String']['output'];
  email?: Maybe<Scalars['String']['output']>;
  emailVerified: Scalars['Boolean']['output'];
  firstName: Scalars['String']['output'];
  gender: Gender;
  id?: Maybe<Scalars['ID']['output']>;
  roles: Array<Scalars['String']['output']>;
};

export type UserCollection = {
  entries: UserCollectionEntryPagination;
  id: Scalars['UUID']['output'];
  title: Scalars['String']['output'];
};


export type UserCollectionEntriesArgs = {
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type UserCollectionEntry = {
  id: Scalars['UUID']['output'];
  item?: Maybe<UserCollectionEntryItem>;
};

export type UserCollectionEntryItem = Episode | Short | Show;

export type UserCollectionEntryPagination = Pagination & {
  first: Scalars['Int']['output'];
  items: Array<UserCollectionEntry>;
  offset: Scalars['Int']['output'];
  total: Scalars['Int']['output'];
};

export type VideoTask = Task & {
  completed: Scalars['Boolean']['output'];
  description?: Maybe<Scalars['String']['output']>;
  episode: Episode;
  id: Scalars['ID']['output'];
  secondaryTitle?: Maybe<Scalars['String']['output']>;
  title: Scalars['String']['output'];
};

export type WebSection = Section & {
  aspectRatio?: Maybe<Scalars['Float']['output']>;
  authentication: Scalars['Boolean']['output'];
  description?: Maybe<Scalars['String']['output']>;
  height?: Maybe<Scalars['Int']['output']>;
  id: Scalars['ID']['output'];
  title?: Maybe<Scalars['String']['output']>;
  url: Scalars['String']['output'];
  widthRatio: Scalars['Float']['output'];
};

export type GetMeQueryVariables = Exact<{ [key: string]: never; }>;


export type GetMeQuery = { me: { bccMember: boolean, analytics: { anonymousId: string } } };

export type SendSupportEmailMutationVariables = Exact<{
  title: Scalars['String']['input'];
  content: Scalars['String']['input'];
  html: Scalars['String']['input'];
}>;


export type SendSupportEmailMutation = { sendSupportEmail: boolean };

export type SimpleEpisodeFragment = { id: string, uuid: string, title: string, image?: string | null, publishDate: any, duration: number };


export type SimpleEpisodeFragmentVariables = Exact<{ [key: string]: never; }>;

export type GetSeasonOnEpisodePageQueryVariables = Exact<{
  seasonId: Scalars['ID']['input'];
  firstEpisodes?: InputMaybe<Scalars['Int']['input']>;
  offsetEpisodes?: InputMaybe<Scalars['Int']['input']>;
}>;


export type GetSeasonOnEpisodePageQuery = { season: { id: string, title: string, image?: string | null, number: number, episodes: { total: number, items: Array<{ number?: number | null, progress?: number | null, description: string, ageRating: string, id: string, uuid: string, title: string, image?: string | null, publishDate: any, duration: number }> }, show: { id: string, title: string, description: string, type: ShowType, image?: string | null } } };

export type LessonProgressOverviewFragment = { id: string, progress: { total: number, completed: number } };


export type LessonProgressOverviewFragmentVariables = Exact<{ [key: string]: never; }>;

export type StreamFragment = { url: string, videoLanguage?: any | null, type: StreamType };


export type StreamFragmentVariables = Exact<{ [key: string]: never; }>;

export type ChapterListChapterFragment = { id: string, title: string, start: number };


export type ChapterListChapterFragmentVariables = Exact<{ [key: string]: never; }>;

export type GetEpisodeQueryVariables = Exact<{
  episodeId: Scalars['ID']['input'];
  context?: InputMaybe<EpisodeContext>;
}>;


export type GetEpisodeQuery = { episode: { description: string, number?: number | null, progress?: number | null, locked: boolean, originalTitle: string, ageRating: string, productionDate: any, productionDateInTitle: boolean, availableFrom: any, availableTo: any, shareRestriction: ShareRestriction, id: string, uuid: string, title: string, image?: string | null, publishDate: any, duration: number, chapters: Array<{ id: string, title: string, start: number }>, streams: Array<{ url: string, videoLanguage?: any | null, type: StreamType }>, files: Array<{ id: string, url: string, fileName: string, audioLanguage: any, subtitleLanguage?: any | null, size: number, resolution?: string | null }>, next: Array<{ id: string }>, lessons: { items: Array<{ id: string, progress: { total: number, completed: number } }> }, context?: { __typename: 'ContextCollection', id: string, slug?: string | null, items?: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } | null } | { __typename: 'Season', id: string } | null, relatedItems?: { items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } | null, season?: { id: string, title: string, number: number, description: string, show: { id: string, title: string, type: ShowType, description: string, seasons: { items: Array<{ id: string, title: string, number: number }> } } } | null } };

export type UpdateEpisodeProgressMutationVariables = Exact<{
  episodeId: Scalars['ID']['input'];
  progress?: InputMaybe<Scalars['Int']['input']>;
  duration?: InputMaybe<Scalars['Int']['input']>;
  context: EpisodeContext;
}>;


export type UpdateEpisodeProgressMutation = { setEpisodeProgress: { progress?: number | null } };

export type GetDefaultEpisodeForShowQueryVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type GetDefaultEpisodeForShowQuery = { show: { defaultEpisode: { id: string } } };

export type GetEpisodeEmbedQueryVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type GetEpisodeEmbedQuery = { episode: { id: string, files: Array<{ id: string, url: string, fileName: string, audioLanguage: any, subtitleLanguage?: any | null, size: number, resolution?: string | null }> } };

export type GetFaqQueryVariables = Exact<{ [key: string]: never; }>;


export type GetFaqQuery = { faq: { categories?: { items: Array<{ title: string, questions?: { items: Array<{ question: string, answer: string }> } | null }> } | null } };

export type SendEpisodeFeedbackMutationVariables = Exact<{
  episodeId: Scalars['ID']['input'];
  rating: Scalars['Int']['input'];
  message?: InputMaybe<Scalars['String']['input']>;
}>;


export type SendEpisodeFeedbackMutation = { sendEpisodeFeedback: string };

export type GetLegacyIdQueryVariables = Exact<{
  episodeId?: InputMaybe<Scalars['Int']['input']>;
  programId?: InputMaybe<Scalars['Int']['input']>;
}>;


export type GetLegacyIdQuery = { legacyIDLookup: { id: string } };

export type GetPageQueryVariables = Exact<{
  code: Scalars['String']['input'];
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  sectionFirst?: InputMaybe<Scalars['Int']['input']>;
  sectionOffset?: InputMaybe<Scalars['Int']['input']>;
}>;


export type GetPageQuery = { page: { id: string, title: string, code: string, sections: { total: number, offset: number, first: number, items: Array<{ __typename: 'AchievementSection', id: string, title?: string | null } | { __typename: 'AvatarSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'CardListSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'CardSection', id: string, title?: string | null, cardSize: CardSectionSize, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string, title: string, description: string, images: Array<{ style: string, url: string }>, lessonsProgress: { completed: number, total: number } } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null } | { __typename: 'DefaultGridSection', id: string, title?: string | null, gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'DefaultSection', id: string, title?: string | null, size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null } | { __typename: 'FeaturedSection', id: string, title?: string | null, size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null } | { __typename: 'IconGridSection', id: string, title?: string | null, gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'IconSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'LabelSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'ListSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'MessageSection', title?: string | null, id: string, messages?: Array<{ title: string, content: string, style: { text: string, background: string, border: string } }> | null } | { __typename: 'PageDetailsSection', id: string, title?: string | null } | { __typename: 'PosterGridSection', id: string, title?: string | null, gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'PosterSection', id: string, title?: string | null, size: SectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'WebSection', title?: string | null, url: string, height?: number | null, aspectRatio?: number | null, authentication: boolean, id: string }> } } };

type ItemSection_AvatarSection_Fragment = { metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } };

type ItemSection_CardListSection_Fragment = { metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } };

type ItemSection_CardSection_Fragment = { cardSize: CardSectionSize, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string, title: string, description: string, images: Array<{ style: string, url: string }>, lessonsProgress: { completed: number, total: number } } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null };

type ItemSection_DefaultGridSection_Fragment = { gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } };

type ItemSection_DefaultSection_Fragment = { size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null };

type ItemSection_FeaturedSection_Fragment = { size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null };

type ItemSection_IconGridSection_Fragment = { gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } };

type ItemSection_IconSection_Fragment = { metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } };

type ItemSection_LabelSection_Fragment = { metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } };

type ItemSection_ListSection_Fragment = { metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } };

type ItemSection_PosterGridSection_Fragment = { gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } };

type ItemSection_PosterSection_Fragment = { size: SectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } };

export type ItemSectionFragment = ItemSection_AvatarSection_Fragment | ItemSection_CardListSection_Fragment | ItemSection_CardSection_Fragment | ItemSection_DefaultGridSection_Fragment | ItemSection_DefaultSection_Fragment | ItemSection_FeaturedSection_Fragment | ItemSection_IconGridSection_Fragment | ItemSection_IconSection_Fragment | ItemSection_LabelSection_Fragment | ItemSection_ListSection_Fragment | ItemSection_PosterGridSection_Fragment | ItemSection_PosterSection_Fragment;


export type ItemSectionFragmentVariables = Exact<{ [key: string]: never; }>;

export type StudyTopicSectionItemFragment = { id: string, title: string, description: string, images: Array<{ style: string, url: string }>, lessonsProgress: { completed: number, total: number } };


export type StudyTopicSectionItemFragmentVariables = Exact<{ [key: string]: never; }>;

export type GetSectionsForPageQueryVariables = Exact<{
  code: Scalars['String']['input'];
  first?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  sectionFirst?: InputMaybe<Scalars['Int']['input']>;
  sectionOffset?: InputMaybe<Scalars['Int']['input']>;
}>;


export type GetSectionsForPageQuery = { page: { id: string, sections: { total: number, offset: number, first: number, items: Array<{ __typename: 'AchievementSection', id: string, title?: string | null } | { __typename: 'AvatarSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'CardListSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'CardSection', id: string, title?: string | null, cardSize: CardSectionSize, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string, title: string, description: string, images: Array<{ style: string, url: string }>, lessonsProgress: { completed: number, total: number } } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null } | { __typename: 'DefaultGridSection', id: string, title?: string | null, gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'DefaultSection', id: string, title?: string | null, size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null } | { __typename: 'FeaturedSection', id: string, title?: string | null, size: SectionSize, items: { total: number, first: number, offset: number, items: Array<{ description: string, id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> }, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null } | { __typename: 'IconGridSection', id: string, title?: string | null, gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'IconSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'LabelSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'ListSection', id: string, title?: string | null, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'MessageSection', title?: string | null, id: string, messages?: Array<{ title: string, content: string, style: { text: string, background: string, border: string } }> | null } | { __typename: 'PageDetailsSection', id: string, title?: string | null } | { __typename: 'PosterGridSection', id: string, title?: string | null, gridSize: GridSectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'PosterSection', id: string, title?: string | null, size: SectionSize, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'WebSection', title?: string | null, url: string, height?: number | null, aspectRatio?: number | null, authentication: boolean, id: string }> } } };

export type GetPlaylistEpisodeQueryVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type GetPlaylistEpisodeQuery = { playlist: { items: { items: Array<{ __typename: 'Episode', id: string } | { __typename: 'Short' }> } } };

export type GetRedirectUrlQueryVariables = Exact<{
  code: Scalars['String']['input'];
}>;


export type GetRedirectUrlQuery = { redirect: { url: string } };

export type SearchQueryVariables = Exact<{
  query: Scalars['String']['input'];
  type?: InputMaybe<Scalars['String']['input']>;
  minScore?: InputMaybe<Scalars['Int']['input']>;
}>;


export type SearchQuery = { search: { hits: number, page: number, result: Array<{ __typename: 'EpisodeSearchItem', seasonTitle?: string | null, showTitle?: string | null, id: string, header?: string | null, title: string, description?: string | null, image?: string | null } | { __typename: 'SeasonSearchItem', id: string, header?: string | null, title: string, description?: string | null, image?: string | null } | { __typename: 'ShowSearchItem', id: string, header?: string | null, title: string, description?: string | null, image?: string | null }> } };

export type GetDefaultEpisodeIdQueryVariables = Exact<{
  showId: Scalars['ID']['input'];
}>;


export type GetDefaultEpisodeIdQuery = { show: { defaultEpisode: { id: string } } };

export type SectionItemFragment = { id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } };


export type SectionItemFragmentVariables = Exact<{ [key: string]: never; }>;

export type GetSectionQueryVariables = Exact<{
  id: Scalars['ID']['input'];
  first: Scalars['Int']['input'];
  offset: Scalars['Int']['input'];
}>;


export type GetSectionQuery = { section: { __typename: 'AchievementSection', id: string } | { __typename: 'AvatarSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'CardListSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'CardSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'DefaultGridSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'DefaultSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'FeaturedSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'IconGridSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'IconSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'LabelSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'ListSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'MessageSection', id: string } | { __typename: 'PageDetailsSection', id: string } | { __typename: 'PosterGridSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'PosterSection', id: string, metadata?: { collectionId: string, continueWatching: boolean, useContext: boolean, prependLiveElement: boolean, secondaryTitles: boolean } | null, items: { total: number, first: number, offset: number, items: Array<{ id: string, image?: string | null, title: string, sort: number, item: { __typename: 'Episode', id: string, productionDate: any, publishDate: any, progress?: number | null, duration: number, locked: boolean, ageRating: string, description: string, episodeNumber?: number | null, season?: { id: string, title: string, number: number, show: { id: string, type: ShowType, title: string } } | null } | { __typename: 'Game' } | { __typename: 'Link', id: string, url: string } | { __typename: 'Page', id: string, code: string } | { __typename: 'Person' } | { __typename: 'Playlist', id: string } | { __typename: 'Season', id: string, seasonNumber: number, show: { title: string }, episodes: { items: Array<{ publishDate: any }> } } | { __typename: 'Short' } | { __typename: 'Show', id: string, episodeCount: number, seasonCount: number, seasons: { items: Array<{ episodes: { items: Array<{ publishDate: any }> } }> } } | { __typename: 'StudyTopic', id: string } }> } } | { __typename: 'WebSection', id: string } };

export type GetShortDetailsQueryVariables = Exact<{
  id: Scalars['UUID']['input'];
}>;


export type GetShortDetailsQuery = { short: { image?: string | null, title: string, description?: string | null } };

type Task_AlternativesTask_Fragment = { __typename: 'AlternativesTask', competitionMode: boolean, locked: boolean, id: string, title: string, completed: boolean, alternatives: Array<{ id: string, title: string, isCorrect?: boolean | null, selected: boolean }> };

type Task_LinkTask_Fragment = { __typename: 'LinkTask', secondaryTitle?: string | null, description?: string | null, id: string, title: string, completed: boolean, link: { type: LinkType, title: string, url: string, image?: string | null, description?: string | null } };

type Task_PosterTask_Fragment = { __typename: 'PosterTask', image: string, id: string, title: string, completed: boolean };

type Task_QuoteTask_Fragment = { __typename: 'QuoteTask', image: string, id: string, title: string, completed: boolean };

type Task_TextTask_Fragment = { __typename: 'TextTask', id: string, title: string, completed: boolean };

type Task_VideoTask_Fragment = { __typename: 'VideoTask', secondaryTitle?: string | null, id: string, title: string, completed: boolean, episode: { id: string, image?: string | null, title: string, description: string } };

export type TaskFragment = Task_AlternativesTask_Fragment | Task_LinkTask_Fragment | Task_PosterTask_Fragment | Task_QuoteTask_Fragment | Task_TextTask_Fragment | Task_VideoTask_Fragment;


export type TaskFragmentVariables = Exact<{ [key: string]: never; }>;

export type LessonLinkFragment = { image?: string | null, title: string, description?: string | null, url: string };


export type LessonLinkFragmentVariables = Exact<{ [key: string]: never; }>;

export type GetStudyLessonQueryVariables = Exact<{
  lessonId: Scalars['ID']['input'];
  episodeId: Scalars['ID']['input'];
}>;


export type GetStudyLessonQuery = { studyLesson: { id: string, title: string, progress: { total: number, completed: number }, tasks: { items: Array<{ __typename: 'AlternativesTask', competitionMode: boolean, locked: boolean, id: string, title: string, completed: boolean, alternatives: Array<{ id: string, title: string, isCorrect?: boolean | null, selected: boolean }> } | { __typename: 'LinkTask', secondaryTitle?: string | null, description?: string | null, id: string, title: string, completed: boolean, link: { type: LinkType, title: string, url: string, image?: string | null, description?: string | null } } | { __typename: 'PosterTask', image: string, id: string, title: string, completed: boolean } | { __typename: 'QuoteTask', image: string, id: string, title: string, completed: boolean } | { __typename: 'TextTask', id: string, title: string, completed: boolean } | { __typename: 'VideoTask', secondaryTitle?: string | null, id: string, title: string, completed: boolean, episode: { id: string, image?: string | null, title: string, description: string } }> }, links: { items: Array<{ image?: string | null, title: string, description?: string | null, url: string }> } }, episode: { id: string, title: string, image?: string | null } };

export type GetStudyTopicLessonStatusesQueryVariables = Exact<{
  id: Scalars['ID']['input'];
  first: Scalars['Int']['input'];
}>;


export type GetStudyTopicLessonStatusesQuery = { studyTopic: { lessons: { items: Array<{ id: string, completed: boolean, episodes: { items: Array<{ id: string, locked: boolean }> } }> } } };

export type GetDefaultEpisodeForTopicQueryVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type GetDefaultEpisodeForTopicQuery = { studyTopic: { defaultLesson: { defaultEpisode?: { id: string } | null } } };

export type GetFirstSotmLessonForConsentQueryVariables = Exact<{ [key: string]: never; }>;


export type GetFirstSotmLessonForConsentQuery = { studyLesson: { tasks: { items: Array<{ __typename: 'AlternativesTask', alternatives: Array<{ id: string, selected: boolean }> } | { __typename: 'LinkTask' } | { __typename: 'PosterTask' } | { __typename: 'QuoteTask' } | { __typename: 'TextTask' } | { __typename: 'VideoTask' }> } } };

export type SetStudyConsentTrueMutationVariables = Exact<{ [key: string]: never; }>;


export type SetStudyConsentTrueMutation = { completeTask: boolean };

export type CompleteTaskMutationVariables = Exact<{
  taskId: Scalars['ID']['input'];
  selectedAlternatives?: InputMaybe<Array<Scalars['String']['input']> | Scalars['String']['input']>;
}>;


export type CompleteTaskMutation = { completeTask: boolean };

export type SendTaskMessageMutationVariables = Exact<{
  taskId: Scalars['ID']['input'];
  message: Scalars['String']['input'];
}>;


export type SendTaskMessageMutation = { sendTaskMessage: string };

export type LockAnswersMutationVariables = Exact<{
  lessonId: Scalars['ID']['input'];
}>;


export type LockAnswersMutation = { lockLessonAnswers: boolean };

export type SubscribeToTopicMutationVariables = Exact<{
  topic: SubscriptionTopic;
}>;


export type SubscribeToTopicMutation = { subscribe: boolean };

export type UnsubscribeToTopicMutationVariables = Exact<{
  topic: SubscriptionTopic;
}>;


export type UnsubscribeToTopicMutation = { unsubscribe: boolean };

export type GetSubscriptionsQueryVariables = Exact<{ [key: string]: never; }>;


export type GetSubscriptionsQuery = { subscriptions: Array<SubscriptionTopic> };

export type GetCalendarStatusQueryVariables = Exact<{
  day: Scalars['Date']['input'];
}>;


export type GetCalendarStatusQuery = { calendar?: { day: { entries: Array<{ start: any, end: any } | { start: any, end: any } | { start: any, end: any } | { start: any, end: any }> } } | null };

export type ApplicationQueryVariables = Exact<{ [key: string]: never; }>;


export type ApplicationQuery = { application: { code: string, page?: { code: string } | null, searchPage?: { code: string } | null } };

export const SimpleEpisodeFragmentDoc = gql`
    fragment SimpleEpisode on Episode {
  id
  uuid
  title
  image
  publishDate
  duration
}
    `;
export const LessonProgressOverviewFragmentDoc = gql`
    fragment LessonProgressOverview on Lesson {
  id
  progress {
    total
    completed
  }
}
    `;
export const StreamFragmentDoc = gql`
    fragment Stream on Stream {
  url
  videoLanguage
  type
}
    `;
export const ChapterListChapterFragmentDoc = gql`
    fragment ChapterListChapter on Chapter {
  id
  title
  start
}
    `;
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
      locked
      ageRating
      description
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
    ... on StudyTopic {
      id
    }
    ... on Playlist {
      id
    }
    ... on Link {
      id
      url
    }
  }
}
    `;
export const StudyTopicSectionItemFragmentDoc = gql`
    fragment StudyTopicSectionItem on StudyTopic {
  id
  title
  description
  images {
    style
    url
  }
  lessonsProgress: progress {
    completed
    total
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
  items(first: $sectionFirst, offset: $sectionOffset) {
    total
    first
    offset
    items {
      ...SectionItem
    }
  }
  ... on DefaultSection {
    size
    items(first: $sectionFirst, offset: $sectionOffset) {
      items {
        description
      }
    }
  }
  ... on FeaturedSection {
    size
    items(first: $sectionFirst, offset: $sectionOffset) {
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
  ... on CardSection {
    cardSize: size
    items(first: $sectionFirst, offset: $sectionOffset) {
      items {
        item {
          ... on StudyTopic {
            ...StudyTopicSectionItem
          }
        }
      }
    }
  }
}
    ${SectionItemFragmentDoc}
${StudyTopicSectionItemFragmentDoc}`;
export const TaskFragmentDoc = gql`
    fragment Task on Task {
  __typename
  id
  title
  completed
  ... on AlternativesTask {
    competitionMode
    locked
    alternatives {
      id
      title
      isCorrect
      selected
    }
  }
  ... on PosterTask {
    image
  }
  ... on QuoteTask {
    image
  }
  ... on LinkTask {
    secondaryTitle
    description
    link {
      type
      title
      url
      image
      description
    }
  }
  ... on VideoTask {
    secondaryTitle
    episode {
      id
      image
      title
      description
    }
  }
}
    `;
export const LessonLinkFragmentDoc = gql`
    fragment LessonLink on Link {
  image
  title
  description
  url
}
    `;
export const GetMeDocument = gql`
    query getMe {
  me {
    analytics {
      anonymousId
    }
    bccMember
  }
}
    `;

export function useGetMeQuery(options: Omit<Urql.UseQueryArgs<never, GetMeQueryVariables>, 'query'>) {
  return Urql.useQuery<GetMeQuery, GetMeQueryVariables>({ query: GetMeDocument, ...options });
};
export const SendSupportEmailDocument = gql`
    mutation sendSupportEmail($title: String!, $content: String!, $html: String!) {
  sendSupportEmail(title: $title, content: $content, html: $html)
}
    `;

export function useSendSupportEmailMutation() {
  return Urql.useMutation<SendSupportEmailMutation, SendSupportEmailMutationVariables>(SendSupportEmailDocument);
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
        ...SimpleEpisode
        number
        progress
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
    ${SimpleEpisodeFragmentDoc}`;

export function useGetSeasonOnEpisodePageQuery(options: Omit<Urql.UseQueryArgs<never, GetSeasonOnEpisodePageQueryVariables>, 'query'>) {
  return Urql.useQuery<GetSeasonOnEpisodePageQuery, GetSeasonOnEpisodePageQueryVariables>({ query: GetSeasonOnEpisodePageDocument, ...options });
};
export const GetEpisodeDocument = gql`
    query getEpisode($episodeId: ID!, $context: EpisodeContext) {
  episode(id: $episodeId, context: $context) {
    ...SimpleEpisode
    description
    number
    progress
    locked
    originalTitle
    ageRating
    productionDate
    productionDateInTitle
    availableFrom
    availableTo
    shareRestriction
    chapters {
      ...ChapterListChapter
    }
    streams {
      ...Stream
    }
    files {
      id
      url
      fileName
      audioLanguage
      subtitleLanguage
      size
      resolution
    }
    next {
      id
    }
    lessons {
      items {
        ...LessonProgressOverview
      }
    }
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
        id
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
    ${SimpleEpisodeFragmentDoc}
${ChapterListChapterFragmentDoc}
${StreamFragmentDoc}
${LessonProgressOverviewFragmentDoc}
${SectionItemFragmentDoc}`;

export function useGetEpisodeQuery(options: Omit<Urql.UseQueryArgs<never, GetEpisodeQueryVariables>, 'query'>) {
  return Urql.useQuery<GetEpisodeQuery, GetEpisodeQueryVariables>({ query: GetEpisodeDocument, ...options });
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
export const GetDefaultEpisodeForShowDocument = gql`
    query getDefaultEpisodeForShow($id: ID!) {
  show(id: $id) {
    defaultEpisode {
      id
    }
  }
}
    `;

export function useGetDefaultEpisodeForShowQuery(options: Omit<Urql.UseQueryArgs<never, GetDefaultEpisodeForShowQueryVariables>, 'query'>) {
  return Urql.useQuery<GetDefaultEpisodeForShowQuery, GetDefaultEpisodeForShowQueryVariables>({ query: GetDefaultEpisodeForShowDocument, ...options });
};
export const GetEpisodeEmbedDocument = gql`
    query getEpisodeEmbed($id: ID!) {
  episode(id: $id) {
    id
    files {
      id
      url
      fileName
      audioLanguage
      subtitleLanguage
      size
      resolution
    }
  }
}
    `;

export function useGetEpisodeEmbedQuery(options: Omit<Urql.UseQueryArgs<never, GetEpisodeEmbedQueryVariables>, 'query'>) {
  return Urql.useQuery<GetEpisodeEmbedQuery, GetEpisodeEmbedQueryVariables>({ query: GetEpisodeEmbedDocument, ...options });
};
export const GetFaqDocument = gql`
    query getFAQ {
  faq {
    categories(first: 100) {
      items {
        title
        questions(first: 100) {
          items {
            question
            answer
          }
        }
      }
    }
  }
}
    `;

export function useGetFaqQuery(options: Omit<Urql.UseQueryArgs<never, GetFaqQueryVariables>, 'query'>) {
  return Urql.useQuery<GetFaqQuery, GetFaqQueryVariables>({ query: GetFaqDocument, ...options });
};
export const SendEpisodeFeedbackDocument = gql`
    mutation SendEpisodeFeedback($episodeId: ID!, $rating: Int!, $message: String) {
  sendEpisodeFeedback(episodeId: $episodeId, rating: $rating, message: $message)
}
    `;

export function useSendEpisodeFeedbackMutation() {
  return Urql.useMutation<SendEpisodeFeedbackMutation, SendEpisodeFeedbackMutationVariables>(SendEpisodeFeedbackDocument);
};
export const GetLegacyIdDocument = gql`
    query getLegacyId($episodeId: Int, $programId: Int) {
  legacyIDLookup(options: {episodeID: $episodeId, programID: $programId}) {
    id
  }
}
    `;

export function useGetLegacyIdQuery(options: Omit<Urql.UseQueryArgs<never, GetLegacyIdQueryVariables>, 'query'>) {
  return Urql.useQuery<GetLegacyIdQuery, GetLegacyIdQueryVariables>({ query: GetLegacyIdDocument, ...options });
};
export const GetPageDocument = gql`
    query getPage($code: String!, $first: Int, $offset: Int, $sectionFirst: Int, $sectionOffset: Int) {
  page(code: $code) {
    id
    title
    code
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

export function useGetPageQuery(options: Omit<Urql.UseQueryArgs<never, GetPageQueryVariables>, 'query'>) {
  return Urql.useQuery<GetPageQuery, GetPageQueryVariables>({ query: GetPageDocument, ...options });
};
export const GetSectionsForPageDocument = gql`
    query getSectionsForPage($code: String!, $first: Int, $offset: Int, $sectionFirst: Int, $sectionOffset: Int) {
  page(code: $code) {
    id
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

export function useGetSectionsForPageQuery(options: Omit<Urql.UseQueryArgs<never, GetSectionsForPageQueryVariables>, 'query'>) {
  return Urql.useQuery<GetSectionsForPageQuery, GetSectionsForPageQueryVariables>({ query: GetSectionsForPageDocument, ...options });
};
export const GetPlaylistEpisodeDocument = gql`
    query getPlaylistEpisode($id: ID!) {
  playlist(id: $id) {
    items {
      items {
        __typename
        ... on Episode {
          id
        }
      }
    }
  }
}
    `;

export function useGetPlaylistEpisodeQuery(options: Omit<Urql.UseQueryArgs<never, GetPlaylistEpisodeQueryVariables>, 'query'>) {
  return Urql.useQuery<GetPlaylistEpisodeQuery, GetPlaylistEpisodeQueryVariables>({ query: GetPlaylistEpisodeDocument, ...options });
};
export const GetRedirectUrlDocument = gql`
    query getRedirectUrl($code: String!) {
  redirect(id: $code) {
    url
  }
}
    `;

export function useGetRedirectUrlQuery(options: Omit<Urql.UseQueryArgs<never, GetRedirectUrlQueryVariables>, 'query'>) {
  return Urql.useQuery<GetRedirectUrlQuery, GetRedirectUrlQueryVariables>({ query: GetRedirectUrlDocument, ...options });
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

export function useSearchQuery(options: Omit<Urql.UseQueryArgs<never, SearchQueryVariables>, 'query'>) {
  return Urql.useQuery<SearchQuery, SearchQueryVariables>({ query: SearchDocument, ...options });
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

export function useGetDefaultEpisodeIdQuery(options: Omit<Urql.UseQueryArgs<never, GetDefaultEpisodeIdQueryVariables>, 'query'>) {
  return Urql.useQuery<GetDefaultEpisodeIdQuery, GetDefaultEpisodeIdQueryVariables>({ query: GetDefaultEpisodeIdDocument, ...options });
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

export function useGetSectionQuery(options: Omit<Urql.UseQueryArgs<never, GetSectionQueryVariables>, 'query'>) {
  return Urql.useQuery<GetSectionQuery, GetSectionQueryVariables>({ query: GetSectionDocument, ...options });
};
export const GetShortDetailsDocument = gql`
    query getShortDetails($id: UUID!) {
  short(id: $id) {
    image
    title
    description
  }
}
    `;

export function useGetShortDetailsQuery(options: Omit<Urql.UseQueryArgs<never, GetShortDetailsQueryVariables>, 'query'>) {
  return Urql.useQuery<GetShortDetailsQuery, GetShortDetailsQueryVariables>({ query: GetShortDetailsDocument, ...options });
};
export const GetStudyLessonDocument = gql`
    query getStudyLesson($lessonId: ID!, $episodeId: ID!) {
  studyLesson(id: $lessonId) {
    id
    title
    progress {
      total
      completed
    }
    tasks {
      items {
        ...Task
      }
    }
    links {
      items {
        ...LessonLink
      }
    }
  }
  episode(id: $episodeId) {
    id
    title
    image
  }
}
    ${TaskFragmentDoc}
${LessonLinkFragmentDoc}`;

export function useGetStudyLessonQuery(options: Omit<Urql.UseQueryArgs<never, GetStudyLessonQueryVariables>, 'query'>) {
  return Urql.useQuery<GetStudyLessonQuery, GetStudyLessonQueryVariables>({ query: GetStudyLessonDocument, ...options });
};
export const GetStudyTopicLessonStatusesDocument = gql`
    query GetStudyTopicLessonStatuses($id: ID!, $first: Int!) {
  studyTopic(id: $id) {
    lessons(first: $first) {
      items {
        id
        completed
        episodes(first: 1) {
          items {
            id
            locked
          }
        }
      }
    }
  }
}
    `;

export function useGetStudyTopicLessonStatusesQuery(options: Omit<Urql.UseQueryArgs<never, GetStudyTopicLessonStatusesQueryVariables>, 'query'>) {
  return Urql.useQuery<GetStudyTopicLessonStatusesQuery, GetStudyTopicLessonStatusesQueryVariables>({ query: GetStudyTopicLessonStatusesDocument, ...options });
};
export const GetDefaultEpisodeForTopicDocument = gql`
    query getDefaultEpisodeForTopic($id: ID!) {
  studyTopic(id: $id) {
    defaultLesson {
      defaultEpisode {
        id
      }
    }
  }
}
    `;

export function useGetDefaultEpisodeForTopicQuery(options: Omit<Urql.UseQueryArgs<never, GetDefaultEpisodeForTopicQueryVariables>, 'query'>) {
  return Urql.useQuery<GetDefaultEpisodeForTopicQuery, GetDefaultEpisodeForTopicQueryVariables>({ query: GetDefaultEpisodeForTopicDocument, ...options });
};
export const GetFirstSotmLessonForConsentDocument = gql`
    query getFirstSOTMLessonForConsent {
  studyLesson(id: "5677226a-990b-4c24-b057-a5b0beab63f1") {
    tasks {
      items {
        __typename
        ... on AlternativesTask {
          alternatives {
            id
            selected
          }
        }
      }
    }
  }
}
    `;

export function useGetFirstSotmLessonForConsentQuery(options: Omit<Urql.UseQueryArgs<never, GetFirstSotmLessonForConsentQueryVariables>, 'query'>) {
  return Urql.useQuery<GetFirstSotmLessonForConsentQuery, GetFirstSotmLessonForConsentQueryVariables>({ query: GetFirstSotmLessonForConsentDocument, ...options });
};
export const SetStudyConsentTrueDocument = gql`
    mutation setStudyConsentTrue {
  completeTask(
    id: "9ca12a44-93b3-4c83-8fd6-a1334f0d877e"
    selectedAlternatives: ["fe8c23c2-0aab-4853-a75f-f148400d005a"]
  )
}
    `;

export function useSetStudyConsentTrueMutation() {
  return Urql.useMutation<SetStudyConsentTrueMutation, SetStudyConsentTrueMutationVariables>(SetStudyConsentTrueDocument);
};
export const CompleteTaskDocument = gql`
    mutation completeTask($taskId: ID!, $selectedAlternatives: [String!]) {
  completeTask(id: $taskId, selectedAlternatives: $selectedAlternatives)
}
    `;

export function useCompleteTaskMutation() {
  return Urql.useMutation<CompleteTaskMutation, CompleteTaskMutationVariables>(CompleteTaskDocument);
};
export const SendTaskMessageDocument = gql`
    mutation sendTaskMessage($taskId: ID!, $message: String!) {
  sendTaskMessage(taskId: $taskId, message: $message)
}
    `;

export function useSendTaskMessageMutation() {
  return Urql.useMutation<SendTaskMessageMutation, SendTaskMessageMutationVariables>(SendTaskMessageDocument);
};
export const LockAnswersDocument = gql`
    mutation lockAnswers($lessonId: ID!) {
  lockLessonAnswers(id: $lessonId)
}
    `;

export function useLockAnswersMutation() {
  return Urql.useMutation<LockAnswersMutation, LockAnswersMutationVariables>(LockAnswersDocument);
};
export const SubscribeToTopicDocument = gql`
    mutation subscribeToTopic($topic: SubscriptionTopic!) {
  subscribe(topic: $topic)
}
    `;

export function useSubscribeToTopicMutation() {
  return Urql.useMutation<SubscribeToTopicMutation, SubscribeToTopicMutationVariables>(SubscribeToTopicDocument);
};
export const UnsubscribeToTopicDocument = gql`
    mutation unsubscribeToTopic($topic: SubscriptionTopic!) {
  unsubscribe(topic: $topic)
}
    `;

export function useUnsubscribeToTopicMutation() {
  return Urql.useMutation<UnsubscribeToTopicMutation, UnsubscribeToTopicMutationVariables>(UnsubscribeToTopicDocument);
};
export const GetSubscriptionsDocument = gql`
    query getSubscriptions {
  subscriptions
}
    `;

export function useGetSubscriptionsQuery(options: Omit<Urql.UseQueryArgs<never, GetSubscriptionsQueryVariables>, 'query'>) {
  return Urql.useQuery<GetSubscriptionsQuery, GetSubscriptionsQueryVariables>({ query: GetSubscriptionsDocument, ...options });
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

export function useGetCalendarStatusQuery(options: Omit<Urql.UseQueryArgs<never, GetCalendarStatusQueryVariables>, 'query'>) {
  return Urql.useQuery<GetCalendarStatusQuery, GetCalendarStatusQueryVariables>({ query: GetCalendarStatusDocument, ...options });
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

export function useApplicationQuery(options: Omit<Urql.UseQueryArgs<never, ApplicationQueryVariables>, 'query'>) {
  return Urql.useQuery<ApplicationQuery, ApplicationQueryVariables>({ query: ApplicationDocument, ...options });
};