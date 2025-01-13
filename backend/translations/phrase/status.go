package phrase

type Status string

const (
	StatusAccepted            Status = "ACCEPTED"
	StatusCancelled           Status = "CANCELLED"
	StatusCompleted           Status = "COMPLETED"
	StatusCompletedByLinguist Status = "COMPLETED_BY_LINGUIST"
	StatusDeclined            Status = "DECLINED"
	StatusDelivered           Status = "DELIVERED"
	StatusEmailed             Status = "EMAILED"
	StatusNew                 Status = "NEW"
	StatusRejected            Status = "REJECTED"
)

func (s Status) IsCompleted() bool {
	return s == StatusCompleted || s == StatusCompletedByLinguist
}
