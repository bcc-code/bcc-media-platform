package common

import "github.com/google/uuid"

// ComputedData contains computed things
type ComputedData struct {
	GroupID    uuid.UUID
	ID         uuid.UUID
	Result     string
	Conditions []ComputedCondition
}

// ComputedCondition is to assert if the computed should be applied
type ComputedCondition struct {
	ID       uuid.UUID
	Type     string
	Operator string
	Value    string
}
