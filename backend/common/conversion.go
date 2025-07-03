package common

// Conversion is a generic interface that defines a conversion from one type to another.
// It's used by NewConversionLoader to convert between an original value (O) and a result value (R).
//
// Example:
//
//	type UUIDToStringConversion struct {
//		original uuid.UUID
//		result   string
//	}
//
//	func (c UUIDToStringConversion) GetOriginal() uuid.UUID { return c.original }
//	func (c UUIDToStringConversion) GetResult() string     { return c.result }
type Conversion[O comparable, R any] interface {
	// GetOriginal returns the original key used for the conversion
	GetOriginal() O
	// GetResult returns the converted result
	GetResult() R
}

// TODO: Put into proper file
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
