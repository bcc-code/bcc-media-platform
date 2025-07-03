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
