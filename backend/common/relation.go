package common

// Relation contains a simple id to relation struct
type Relation[k comparable, kr comparable] interface {
	GetKey() k
	GetRelationID() kr
}

// RelationItem implements Relation
type RelationItem[k comparable, kr comparable] struct {
	Key        k
	RelationID kr
}

// GetKey retrieves the key for the item
func (r RelationItem[k, kr]) GetKey() k {
	return r.Key
}

// GetRelationID returns the relation ID
func (r RelationItem[k, kr]) GetRelationID() kr {
	return r.RelationID
}
