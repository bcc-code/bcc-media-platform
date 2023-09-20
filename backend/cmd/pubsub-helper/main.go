package main

// This is just a simple helper, to set up a topic & push subscription
// on the pubsub emulator, and then send some message.
// Cleanup is done at the end so the program can be re-run w/o errors
import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/google/uuid"

	"cloud.google.com/go/pubsub"
	"github.com/bcc-code/bcc-media-platform/backend/events"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/davecgh/go-spew/spew"
)

func create(projectID, topicID string) {
	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
		fmt.Printf("pubsub.NewClient: %v", err)
	}
	defer client.Close()

	topic, err := client.CreateTopic(ctx, topicID)
	if err != nil {
		fmt.Printf("pubsub.NewClient: %v", err)
	}

	t, err := client.CreateSubscription(ctx, "bgjobs", pubsub.SubscriptionConfig{
		Topic: topic,
		PushConfig: pubsub.PushConfig{
			Endpoint: "http://host.docker.internal:8078/api/message",
		},
	})
	if err != nil {
		fmt.Printf("CreateTopic: %v", err)
	}
	fmt.Printf("Sub Created: %v\n", t)
}

func send(projectID, topicID string) {
	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
		fmt.Printf("pubsub.NewClient: %v", err)
	}
	defer client.Close()

	e := cloudevents.NewEvent()
	e.SetSource(events.SourceMediaBanken)
	e.SetType(events.TypeAssetDelivered)
	e.SetData(cloudevents.ApplicationJSON, &events.AssetDelivered{
		JSONMetaPath: "230319_TestSeq01_0caf653e1a915d34/230319_TestSeq01.json",
		//JSONMetaPath: "muxed-test/BIEX_S01_E02_Trailer.smil",
	})

	data, err := json.Marshal(e)
	println(string(data))
	topic := client.Topic(topicID)
	msg := topic.Publish(ctx, &pubsub.Message{
		Data: data,
	})

	_, err = msg.Get(ctx)
	fmt.Printf("Sent: %v\n", err)
}

func refreshView(projectID, topicID string) {
	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
		fmt.Printf("pubsub.NewClient: %v", err)
	}
	defer client.Close()

	e := cloudevents.NewEvent()
	e.SetSource(events.SourceCloudScheduler)
	e.SetType(events.TypeRefreshView)
	e.SetData(cloudevents.ApplicationJSON, &events.RefreshView{
		ViewName: "episodes_access",
		Force:    false,
	})

	data, err := json.Marshal(e)
	spew.Dump(string(data))
	topic := client.Topic(topicID)
	msg := topic.Publish(ctx, &pubsub.Message{
		Data: data,
	})

	_, err = msg.Get(ctx)
	fmt.Printf("Sent: %v\n", err)
}

func del(projectID, topicID string) {
	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
		fmt.Printf("pubsub.NewClient: %v", err)
	}
	defer client.Close()
	sub := client.Subscription("bgjobs")
	err = sub.Delete(ctx)
	if err != nil {
		fmt.Printf("Error deleting sub: %v", err)
	}

	topic := client.Topic(topicID)
	err = topic.Delete(ctx)
	if err != nil {
		fmt.Printf("Error deleting sub: %v", err)
	}

	fmt.Printf("Deleted")
}

func simpleEvent(projectID string, topicID string, event string) {
	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
		fmt.Printf("pubsub.NewClient: %v", err)
	}
	defer client.Close()

	e := cloudevents.NewEvent()
	e.SetID(uuid.New().String())
	e.SetSource("pubsub-helper")
	e.SetType(event)

	data, err := json.Marshal(e)
	spew.Dump(string(data))
	topic := client.Topic(topicID)
	msg := topic.Publish(ctx, &pubsub.Message{
		Data: data,
	})

	_, err = msg.Get(ctx)
	fmt.Printf("Sent: %v\n", err)
}

func directusHook(projectID string, topicID string, event string, collection string, id string) {
	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
		fmt.Printf("pubsub.NewClient: %v", err)
	}
	defer client.Close()

	e := cloudevents.NewEvent()
	e.SetID(uuid.New().String())
	e.SetSource("pubsub-helper")
	e.SetType(events.TypeDirectusEvent)
	e.SetData(cloudevents.ApplicationJSON, events.Event{
		Event:      event,
		Collection: collection,
		ID:         id,
	})

	data, err := json.Marshal(e)
	spew.Dump(string(data))
	topic := client.Topic(topicID)
	msg := topic.Publish(ctx, &pubsub.Message{
		Data: data,
	})

	_, err = msg.Get(ctx)
	fmt.Printf("Sent: %v\n", err)
}

func main() {
	task := flag.String("task", "", "")
	host := flag.String("host", "", "")
	flag.Parse()
	projectId := "btv-local"
	topicId := "background-jobs"

	if host != nil && *host != "" {
		log.Default().Println("Setting host")
		_ = os.Setenv("PUBSUB_EMULATOR_HOST", *host)
	}

	switch *task {
	case "create":
		create(projectId, topicId)
	case "delete":
		del(projectId, topicId)
	case "refreshView":
		refreshView(projectId, topicId)
	case "syncTranslations":
		simpleEvent(projectId, topicId, events.TypeTranslationsSync)
	case "exportAnswers":
		simpleEvent(projectId, topicId, events.TypeExportAnswersToBQ)
	case "searchReindex":
		simpleEvent(projectId, topicId, events.TypeSearchReindex)
	case "ingest":
		send(projectId, topicId)
	case "show.update":
		directusHook(projectId, topicId, "items.update", "shows", "1")
	case "season.update":
		directusHook(projectId, topicId, "items.update", "seasons", "1")
	case "episode.update":
		directusHook(projectId, topicId, "items.update", "episodes", "1")
	default:
		create(projectId, topicId)

		refreshView(projectId, topicId)

		time.Sleep(1 * time.Second)
		del(projectId, topicId)
	}

}
