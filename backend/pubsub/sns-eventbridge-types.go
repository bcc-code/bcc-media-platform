package pubsub

import "encoding/json"

/*
{
	"version": "0",
	"id": "1be9159e-42b2-b168-57ef-d9ef4b0d9860",
	"detail-type": "MediaPackage Input Notification",
	"source": "aws.mediapackage",
	"account": "742348992291",
	"time": "2022-10-12T10:22:37Z",
	"region": "eu-north-1",
	"resources": [
		"arn:aws:mediapackage-vod:eu-north-1:742348992291:assets/BIHE_S01_E06_SEQ_V2-0d26d924-cdac-4223-87d7-560ae21fe7c4"
	],
	"detail": {
	"event": "IngestComplete",
	"message": "Ingest Completed"
	}
}

{
    "version": "0",
    "id": "369552b1-49ec-9872-67be-c16bb4ffcd19",
    "detail-type": "MediaPackage Input Notification",
    "source": "aws.mediapackage",
    "account": "742348992291",
    "time": "2022-10-12T10:22:41Z",
    "region": "eu-north-1",
    "resources": [
        "arn:aws:mediapackage-vod:eu-north-1:742348992291:assets/BIHE_S01_E06_SEQ_V2-0d26d924-cdac-4223-87d7-560ae21fe7c4",
        "arn:aws:mediapackage-vod:eu-north-1:742348992291:packaging-configurations/DASH"
    ],
    "detail": {
        "event": "VodAssetPlayable",
        "message": "Asset 'BIHE_S01_E06_SEQ_V2-0d26d924-cdac-4223-87d7-560ae21fe7c4' is now playable for PackagingConfiguration 'DASH'",
        "packaging_configuration_id": "DASH",
        "manifest_urls": [
            "https://f15c8d265fb75b56d113e4f35dd6a293.egress.mediapackage-vod.eu-north-1.amazonaws.com/out/v1/c5ffa734ab0b423bacbb36971594d15b/0f6b7965074b435590c1a6d4aa062a12/040c64786ba74e76a4251785751bf330/index.mpd"
        ]
    }
}
*/

// ParseMediaPackageNotification parses a string into MediaPackageInputNotification
func ParseMediaPackageNotification(data string) (*MediaPackageInputNotification, error) {
	mpin := &MediaPackageInputNotification{}
	err := json.Unmarshal([]byte(data), mpin)
	return mpin, err
}

type mediaPackageInputNotificationDetail struct {
	Event                   string   `json:"event"`
	Message                 string   `json:"message"`
	PackagingConfiguraionID string   `json:"packaging_configuraion_id"`
	ManifestURLs            []string `json:"manifest_urls"`
}

type MediaPackageInputNotification struct {
	Version    string                              `json:"version"`
	ID         string                              `json:"id"`
	DetailType string                              `json:"detail-type"`
	Source     string                              `json:"source"`
	Account    string                              `json:"account"`
	Time       string                              `json:"time"`
	Region     string                              `json:"region"`
	Resources  []string                            `json:"resources"`
	Detail     mediaPackageInputNotificationDetail `json:"detail"`
}
