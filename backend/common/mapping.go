package common

// Mapping is a simple Key/Value pair used by loader factories that need to
// carry both a lookup key and a value through a batch result. It replaces
// the old Relation and Conversion interfaces, which existed only to provide
// the same shape via accessor methods.
//
// For 1:N relations, the Key is the parent and the Value is a child.
// For 1:1 conversions (e.g. code -> id), the Key is the original lookup key
// and the Value is the converted result.
type Mapping[K comparable, V any] struct {
	Key   K
	Value V
}
