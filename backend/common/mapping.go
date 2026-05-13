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

// GetKey makes Mapping satisfy loaders.HasKey[K] so it can be used directly with
// the generic New / NewListLoader factories without an explicit WithKeyFunc.
func (m Mapping[K, V]) GetKey() K { return m.Key }

// MappingValues unwraps a slice of *Mapping into the bare values, dropping nils.
// Common when a list loader returns the parent->child mappings but the caller
// only needs the children.
func MappingValues[K comparable, V any](ms []*Mapping[K, V]) []V {
	out := make([]V, 0, len(ms))
	for _, m := range ms {
		if m == nil {
			continue
		}
		out = append(out, m.Value)
	}
	return out
}
