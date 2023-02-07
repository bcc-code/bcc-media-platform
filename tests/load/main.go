package main

import (
	"fmt"
	"github.com/bcc-code/brunstadtv/tests/load/graph"
	"github.com/bcc-code/brunstadtv/tests/load/request"
	"github.com/lib/pq"
	"github.com/samber/lo"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

func main() {
	os.Setenv("API_ENDPOINT", "http://localhost:8077/query")

	var devices []request.Device

	for i := 0; i < 10; i++ {
		devices = append(devices, request.Device{
			ID: strconv.Itoa(i),
		})
	}

	reqs := graph.GetRequestsForDevices(devices)

	var channels []chan []request.RequestRun
	client := &http.Client{Timeout: time.Second * 5}
	for _, r := range reqs {
		ch := lo.Async(func() []request.RequestRun {
			defer log.Print("Done")
			return request.Do(client, r)
		})
		channels = append(channels, ch)
	}

	csv := "name,device_id,started,ended"

	for _, ch := range channels {
		runs := <-ch

		for _, run := range runs {
			errString := ""
			if run.Error != nil {
				errString = pq.QuoteLiteral(fmt.Sprint(run.Error))
			}
			csv += fmt.Sprintf("\n%s,%s,%d,%d,%s", run.Name, run.DeviceID, run.Started.Nanosecond(), run.Ended.Nanosecond(), errString)
		}
	}

	os.WriteFile("out.csv", []byte(csv), os.ModePerm)

	log.Print("WHAT")
}
