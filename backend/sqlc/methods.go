package sqlc

type IModel interface {
	GetId() int
	GetModelName() string
}

type ITranslation interface {
	GetTitle() string
	GetDescription() string
	GetLanguage() string
	GetParentId() int
}

func (t Episode) GetId() int {
	return int(t.ID)
}
func (t Episode) GetModelName() string {
	return "episode"
}
func (t EpisodesTranslation) GetTitle() string {
	return t.Title.ValueOrZero()
}
func (t EpisodesTranslation) GetDescription() string {
	return t.Description.ValueOrZero()
}
func (t EpisodesTranslation) GetLanguage() string {
	return t.LanguagesCode
}
func (t EpisodesTranslation) GetParentId() int {
	return int(t.EpisodesID)
}

func (t Show) GetId() int {
	return int(t.ID)
}
func (t Show) GetModelName() string {
	return "show"
}
func (t ShowsTranslation) GetTitle() string {
	return t.Title.ValueOrZero()
}
func (t ShowsTranslation) GetDescription() string {
	return t.Description.ValueOrZero()
}
func (t ShowsTranslation) GetLanguage() string {
	return t.LanguagesCode
}
func (t ShowsTranslation) GetParentId() int {
	return int(t.ShowsID)
}

func (t Season) GetId() int {
	return int(t.ID)
}
func (t Season) GetModelName() string {
	return "season"
}
func (t SeasonsTranslation) GetTitle() string {
	return t.Title.ValueOrZero()
}
func (t SeasonsTranslation) GetDescription() string {
	return t.Description.ValueOrZero()
}
func (t SeasonsTranslation) GetLanguage() string {
	return t.LanguagesCode
}
func (t SeasonsTranslation) GetParentId() int {
	return int(t.SeasonsID)
}
