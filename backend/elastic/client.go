package elastic

import (
	"context"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/elastic/go-elasticsearch/v8"
)

// Client contains methods for use with Elastic
type Client struct {
	es *elasticsearch.Client
}

// New client
func New(cfg elasticsearch.Config) *Client {
	es, err := elasticsearch.NewClient(cfg)
	if err != nil {
		log.L.Error().Err(err)
	}
	return &Client{
		es: es,
	}
}

// Ping to verify that the connection works
func (c *Client) Ping(ctx context.Context) error {
	res, err := c.es.Ping(c.es.Ping.WithContext(ctx))
	if err != nil {
		return err
	}
	if res.IsError() {
		return merry.New("Couldn't ping Elasticsearch cluster")
	}
	return nil
}
