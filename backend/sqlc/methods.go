package sqlc

type IRelatedItem interface {
	GetRelatedItemId() int
}

func (t Episode) GetId() int {
	return int(t.ID)
}
func (t EpisodesTranslation) GetRelatedItemId() int {
	return int(t.EpisodesID)
}

func (t Show) GetId() int {
	return int(t.ID)
}
func (t ShowsTranslation) GetRelatedItemId() int {
	return int(t.ShowsID)
}

func (t Season) GetId() int {
	return int(t.ID)
}
func (t SeasonsTranslation) GetRelatedItemId() int {
	return int(t.SeasonsID)
}
