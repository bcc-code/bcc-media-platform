package phrase

import "time"

type Config struct {
	BaseURL     string
	Username    string
	Password    string
	ProjectUID  string
	CallbackURL string
	UserUID     string
}

type loginRequest struct {
	UserName string `json:"userName"`
	Password string `json:"password"`
	UserUID  string `json:"userUid"`
	Remember bool   `json:"rememberMe"`
}

type LoginResponse struct {
	User                               phraseUser `json:"user"`
	Token                              string     `json:"token"`
	Expires                            string     `json:"expires"`
	LastInvalidateAllSessionsPerformed string     `json:"lastInvalidateAllSessionsPerformed"`
}

type phraseUser struct {
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
	UserName  string `json:"userName"`
	Email     string `json:"email"`
	Role      string `json:"role"`
	ID        string `json:"id"`
	UID       string `json:"uid"`
}

type Job struct {
	UID                   string            `json:"uid"`
	InnerID               string            `json:"innerId"`
	Status                Status            `json:"status"`
	Providers             []Providers       `json:"providers"`
	SourceLang            string            `json:"sourceLang"`
	TargetLang            string            `json:"targetLang"`
	WorkflowLevel         int               `json:"workflowLevel"`
	WorkflowStep          WorkflowStep      `json:"workflowStep"`
	Filename              string            `json:"filename"`
	DateDue               Datetime          `json:"dateDue"`
	WordsCount            int               `json:"wordsCount"`
	BeginIndex            int               `json:"beginIndex"`
	EndIndex              int               `json:"endIndex"`
	IsParentJobSplit      bool              `json:"isParentJobSplit"`
	UpdateSourceDate      Datetime          `json:"updateSourceDate"`
	UpdateTargetDate      Datetime          `json:"updateTargetDate"`
	DateCreated           Datetime          `json:"dateCreated"`
	JobReference          JobReference      `json:"jobReference"`
	Project               Project           `json:"project"`
	LastWorkflowLevel     int               `json:"lastWorkflowLevel"`
	WorkUnit              WorkUnit          `json:"workUnit"`
	ImportStatus          ImportStatus      `json:"importStatus"`
	Imported              bool              `json:"imported"`
	Continuous            bool              `json:"continuous"`
	ContinuousJobInfo     ContinuousJobInfo `json:"continuousJobInfo"`
	OriginalFileDirectory string            `json:"originalFileDirectory"`
	ServerTaskID          string            `json:"serverTaskId"`
}

type UpdateSourceRequest struct {
	Jobs                       []Job  `json:"jobs"`
	PreTranslate               bool   `json:"preTranslate"`
	AllowAutomaticPostAnalysis bool   `json:"allowAutomaticPostAnalysis"`
	CallbackURL                string `json:"callbackUrl"`
}

type CreateJobHeader struct {
	TargetLangs []string `json:"targetLangs"`
	CallbackURL string   `json:"callbackUrl"`
	Due         string   `json:"due,omitempty"`
	Path        string   `json:"path"`
}

type JobsList struct {
	Sort             interface{} `json:"sort"`
	PageNumber       int         `json:"pageNumber"`
	Content          []Job       `json:"content"`
	NumberOfElements int         `json:"numberOfElements"`

	TotalElements int `json:"totalElements"`
	PageSize      int `json:"pageSize"`
	TotalPages    int `json:"totalPages"`
}

type BusinessUnit struct {
	UID  string `json:"uid"`
	Name string `json:"name"`
}
type Domain struct {
	UID  string `json:"uid"`
	Name string `json:"name"`
}
type SubDomain struct {
	UID  string `json:"uid"`
	Name string `json:"name"`
}
type CostCenter struct {
	UID  string `json:"uid"`
	Name string `json:"name"`
}
type CreatedBy struct {
	UID       string `json:"uid"`
	Username  string `json:"username"`
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
}
type Owner struct {
	UID       string `json:"uid"`
	Username  string `json:"username"`
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
}
type Organization struct {
	UID  string `json:"uid"`
	Name string `json:"name"`
}
type Vendor struct {
	UID          string       `json:"uid"`
	VendorUID    string       `json:"vendorUid"`
	Username     string       `json:"username"`
	FirstName    string       `json:"firstName"`
	LastName     string       `json:"lastName"`
	Organization Organization `json:"organization"`
}
type Progress struct {
	TotalCount    int `json:"totalCount"`
	FinishedCount int `json:"finishedCount"`
	OverdueCount  int `json:"overdueCount"`
	FinishedRatio int `json:"finishedRatio"`
	OverdueRatio  int `json:"overdueRatio"`
}
type Options struct {
	UID   string `json:"uid"`
	Value string `json:"value"`
}
type Metadata struct {
	UID       string    `json:"uid"`
	FieldName string    `json:"fieldName"`
	Value     string    `json:"value"`
	Options   []Options `json:"options"`
	Project   Project   `json:"project"`
}
type Project struct {
	UID           string       `json:"uid"`
	InnerID       int          `json:"innerId"`
	Name          string       `json:"name"`
	BusinessUnit  BusinessUnit `json:"businessUnit"`
	Domain        Domain       `json:"domain"`
	SubDomain     SubDomain    `json:"subDomain"`
	Client        Client       `json:"client"`
	CostCenter    CostCenter   `json:"costCenter"`
	DueDate       Datetime     `json:"dueDate"`
	CreatedDate   Datetime     `json:"createdDate"`
	CreatedBy     CreatedBy    `json:"createdBy"`
	Owner         Owner        `json:"owner"`
	Vendor        Vendor       `json:"vendor"`
	PurchaseOrder string       `json:"purchaseOrder"`
	SourceLang    string       `json:"sourceLang"`
	TargetLangs   []string     `json:"targetLangs"`
	Status        Status       `json:"status"`
	Progress      Progress     `json:"progress"`
	Metadata      []Metadata   `json:"metadata"`
	Note          string       `json:"note"`
	Deleted       bool         `json:"deleted"`
	Archived      bool         `json:"archived"`
}
type Providers struct {
	UID        string   `json:"uid"`
	Names      []string `json:"names"`
	Type       string   `json:"type"`
	Anonymized bool     `json:"anonymized"`
	Deleted    bool     `json:"deleted"`
	Active     bool     `json:"active"`
}
type WorkflowStep struct {
	UID          string `json:"uid"`
	Name         string `json:"name"`
	Abbreviation string `json:"abbreviation"`
	Order        int    `json:"order"`
	LqaEnabled   bool   `json:"lqaEnabled"`
}
type SecuritySettings struct {
	CanEdit        bool `json:"canEdit"`
	CanEditDueDate bool `json:"canEditDueDate"`
	CanDelete      bool `json:"canDelete"`
}
type Settings struct {
	SecuritySettings SecuritySettings `json:"securitySettings"`
}
type CreationTask struct {
	ErrorCode    string `json:"errorCode"`
	ErrorMessage string `json:"errorMessage"`
	DataText     string `json:"dataText"`
	Status       Status `json:"status"`
}
type LastTask struct {
	ErrorCode    string `json:"errorCode"`
	ErrorMessage string `json:"errorMessage"`
	DataText     string `json:"dataText"`
	Status       Status `json:"status"`
}
type Errors struct {
	CreationTask CreationTask `json:"creationTask"`
	LastTask     LastTask     `json:"lastTask"`
}
type JobReference struct {
	UID              string       `json:"uid"`
	JobUID           string       `json:"jobUid"`
	Filename         string       `json:"filename"`
	SourceLocale     string       `json:"sourceLocale"`
	TargetLocale     string       `json:"targetLocale"`
	SourceLang       string       `json:"sourceLang"`
	TargetLang       string       `json:"targetLang"`
	WordCount        int          `json:"wordCount"`
	Progress         int          `json:"progress"`
	Level            int          `json:"level"`
	DueDate          Datetime     `json:"dueDate"`
	CreatedDate      Datetime     `json:"createdDate"`
	JobCreatedDate   Datetime     `json:"jobCreatedDate"`
	LastModifiedDate Datetime     `json:"lastModifiedDate"`
	Status           Status       `json:"status"`
	Project          Project      `json:"project"`
	CreatedBy        CreatedBy    `json:"createdBy"`
	Owner            Owner        `json:"owner"`
	Providers        []Providers  `json:"providers"`
	WorkflowStep     WorkflowStep `json:"workflowStep"`
	Continuous       bool         `json:"continuous"`
	LqaScore         bool         `json:"lqaScore"`
	Settings         Settings     `json:"settings"`
	Warnings         []string     `json:"warnings"`
	Errors           Errors       `json:"errors"`
}

type WorkUnit struct {
}

type ImportStatus struct {
	Status       Status `json:"status"`
	ErrorMessage string `json:"errorMessage"`
}

type ContinuousJobInfo struct {
	DateUpdated Datetime `json:"dateUpdated"`
}

type WebhookEvent struct {
	JobParts  []JobParts      `json:"jobParts"`
	Metadata  WebhookMetadata `json:"metadata"`
	Event     string          `json:"event"`
	Timestamp int             `json:"timestamp"`
	EventUID  string          `json:"eventUid"`
}

type JobParts struct {
	ID               int           `json:"id"`
	UID              string        `json:"uid"`
	InternalID       string        `json:"internalId"`
	Task             string        `json:"task"`
	FileName         string        `json:"fileName"`
	TargetLang       string        `json:"targetLang"`
	WorkflowLevel    int           `json:"workflowLevel"`
	Status           Status        `json:"status"`
	WordsCount       int           `json:"wordsCount"`
	BeginIndex       int           `json:"beginIndex"`
	EndIndex         int           `json:"endIndex"`
	IsParentJobSplit bool          `json:"isParentJobSplit"`
	DateCreated      Datetime      `json:"dateCreated"`
	Project          Project       `json:"project"`
	AssignedTo       []interface{} `json:"assignedTo"`
}

type WebhookMetadata struct {
	Project Project `json:"project"`
}

type ResultFileRequest struct {
	AsyncRequest *AsyncRequest `json:"asyncRequest"`
	Reference    Reference     `json:"reference"`
}

type Args map[string]string

type ErrorDetails struct {
	Code    string `json:"code"`
	Args    Args   `json:"args"`
	Message string `json:"message"`
}
type Warnings struct {
	Code    string `json:"code"`
	Args    Args   `json:"args"`
	Message string `json:"message"`
}
type AsyncResponse struct {
	DateCreated  Datetime       `json:"dateCreated"`
	ErrorCode    string         `json:"errorCode"`
	ErrorDesc    string         `json:"errorDesc"`
	ErrorDetails []ErrorDetails `json:"errorDetails"`
	Warnings     []Warnings     `json:"warnings"`
}
type Parent struct {
	ID string `json:"id"`
}
type ParentInt struct {
	ID int `json:"id"`
}
type AsyncRequestInt struct {
	ID            int           `json:"id"`
	CreatedBy     CreatedBy     `json:"createdBy"`
	DateCreated   Datetime      `json:"dateCreated"`
	Action        string        `json:"action"`
	AsyncResponse AsyncResponse `json:"asyncResponse"`
	Parent        ParentInt     `json:"parent"`
	Project       Project       `json:"project"`
}
type AsyncRequest struct {
	ID            string        `json:"id"`
	CreatedBy     CreatedBy     `json:"createdBy"`
	DateCreated   Datetime      `json:"dateCreated"`
	Action        string        `json:"action"`
	AsyncResponse AsyncResponse `json:"asyncResponse"`
	Parent        Parent        `json:"parent"`
	Project       Project       `json:"project"`
}
type Reference struct {
	UID  string `json:"uid"`
	Type string `json:"type"`
}

type WebhookPost struct {
	JobParts     []JobParts       `json:"jobParts"`
	Metadata     Metadata         `json:"metadata"`
	Event        string           `json:"event"`
	Timestamp    int              `json:"timestamp"`
	EventUID     string           `json:"eventUid"`
	AsyncRequest *AsyncRequestInt `json:"asyncRequest"`
}

type MachineTranslateSettings struct {
	ID      int    `json:"id"`
	UID     string `json:"uid"`
	Name    string `json:"name"`
	Type    string `json:"type"`
	Default bool   `json:"default"`
	Args    Args   `json:"args"`
}
type LangSettings struct {
	TargetLang string `json:"targetLang"`
}
type TargetLength struct {
	Enabled bool `json:"enabled"`
	Max     int  `json:"max"`
}
type ForbiddenStrings struct {
	Enabled bool          `json:"enabled"`
	List    []interface{} `json:"list"`
}
type TargetLengthPercent struct {
	Enabled bool    `json:"enabled"`
	Max     float64 `json:"max"`
}
type QualityAssuranceSettings struct {
	EmptyTranslation               bool                `json:"emptyTranslation"`
	InconsistentTranslation        bool                `json:"inconsistentTranslation"`
	JoinTags                       bool                `json:"joinTags"`
	MissingNumbers                 bool                `json:"missingNumbers"`
	SegmentNotConfirmed            bool                `json:"segmentNotConfirmed"`
	Terminology                    bool                `json:"terminology"`
	MultipleSpaces                 bool                `json:"multipleSpaces"`
	TrailingSpace                  bool                `json:"trailingSpace"`
	TrailingPunctuation            bool                `json:"trailingPunctuation"`
	TargetLength                   TargetLength        `json:"targetLength"`
	Formatting                     bool                `json:"formatting"`
	UnresolvedComment              bool                `json:"unresolvedComment"`
	EmptyPairTags                  bool                `json:"emptyPairTags"`
	StrictJobStatus                bool                `json:"strictJobStatus"`
	ForbiddenStrings               ForbiddenStrings    `json:"forbiddenStrings"`
	ExcludeLockedSegments          bool                `json:"excludeLockedSegments"`
	IgnoreNotApprovedTerms         bool                `json:"ignoreNotApprovedTerms"`
	SpellCheck                     bool                `json:"spellCheck"`
	RepeatedWords                  bool                `json:"repeatedWords"`
	InconsistentTagContent         bool                `json:"inconsistentTagContent"`
	EmptyTagContent                bool                `json:"emptyTagContent"`
	XliffTags                      bool                `json:"xliffTags"`
	NestedTags                     bool                `json:"nestedTags"`
	ForbiddenTerms                 bool                `json:"forbiddenTerms"`
	TargetLengthPercent            TargetLengthPercent `json:"targetLengthPercent"`
	TargetLengthPerSegment         bool                `json:"targetLengthPerSegment"`
	NewerAtPrecedingWorkflowStep   bool                `json:"newerAtPrecedingWorkflowStep"`
	LeadingAndTrailingSpaces       bool                `json:"leadingAndTrailingSpaces"`
	IgnoreInAllWorkflowSteps       bool                `json:"ignoreInAllWorkflowSteps"`
	UnmodifiedFuzzyTranslation     bool                `json:"unmodifiedFuzzyTranslation"`
	UnmodifiedFuzzyTranslationTM   bool                `json:"unmodifiedFuzzyTranslationTM"`
	UnmodifiedFuzzyTranslationMTNT bool                `json:"unmodifiedFuzzyTranslationMTNT"`
	ExtraNumbers                   bool                `json:"extraNumbers"`
	TargetSourceIdentical          bool                `json:"targetSourceIdentical"`
	FuzzyInconsistency             bool                `json:"fuzzyInconsistency"`
	CustomQa                       bool                `json:"customQa"`
	DoNotTranslate                 bool                `json:"doNotTranslate"`
}
type AnalyseSettings struct {
	Type                             string        `json:"type"`
	IncludeFuzzyRepetitions          bool          `json:"includeFuzzyRepetitions"`
	IncludeNonTranslatables          bool          `json:"includeNonTranslatables"`
	IncludeMachineTranslationMatches bool          `json:"includeMachineTranslationMatches"`
	IncludeConfirmedSegments         bool          `json:"includeConfirmedSegments"`
	IncludeNumbers                   bool          `json:"includeNumbers"`
	IncludeLockedSegments            bool          `json:"includeLockedSegments"`
	CountSourceUnits                 bool          `json:"countSourceUnits"`
	IncludeTransMemory               bool          `json:"includeTransMemory"`
	NamingPattern                    string        `json:"namingPattern"`
	AnalyzeByLinguist                bool          `json:"analyzeByLinguist"`
	AnalyzeByLanguage                bool          `json:"analyzeByLanguage"`
	AllowAutomaticPostAnalysis       bool          `json:"allowAutomaticPostAnalysis"`
	ConfirmedSegmentsOnly            bool          `json:"confirmedSegmentsOnly"`
	ConfirmedOnlyByUsers             []interface{} `json:"confirmedOnlyByUsers"`
}

type AccessSettings struct {
	DownloadEnabled                      bool `json:"downloadEnabled"`
	WebEditorEnabledForLinguists         bool `json:"webEditorEnabledForLinguists"`
	ShowUserDataToLinguists              bool `json:"showUserDataToLinguists"`
	EmailNotifications                   bool `json:"emailNotifications"`
	AllowLoadingExternalContentInEditors bool `json:"allowLoadingExternalContentInEditors"`
	AllowLoadingIframes                  bool `json:"allowLoadingIframes"`
	StrictWorkflowFinish                 bool `json:"strictWorkflowFinish"`
	UseVendors                           bool `json:"useVendors"`
	LinguistsMayEditLockedSegments       bool `json:"linguistsMayEditLockedSegments"`
	LinguistsMayEditTagContent           bool `json:"linguistsMayEditTagContent"`
	LinguistsMayEditSource               bool `json:"linguistsMayEditSource"`
	LinguistsMaySetAutoPropagation       bool `json:"linguistsMaySetAutoPropagation"`
	UserMaySetInstantQA                  bool `json:"userMaySetInstantQA"`
	TriggerWebhooks                      bool `json:"triggerWebhooks"`
}

type FinancialSettings struct {
}

type ImportResult struct {
	Warnings []interface{} `json:"warnings"`
}

type By struct {
	ID        int    `json:"id"`
	UserName  string `json:"userName"`
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
	Email     string `json:"email"`
	Role      string `json:"role"`
	Active    bool   `json:"active"`
	Deleted   bool   `json:"deleted"`
}
type LastModified struct {
	Date time.Time `json:"date"`
	By   By        `json:"by"`
}

type AsyncRequestResponse struct {
	AsyncRequest AsyncRequest `json:"asyncRequest"`
}
