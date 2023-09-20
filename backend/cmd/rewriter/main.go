package main

import (
	"bytes"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/bcc-media-platform/backend/version"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
	"golang.org/x/net/html"
	"net/http"
)

func (rw *rewriter) getDefaultHtml() (*html.Node, error) {
	req, err := http.NewRequest("GET", rw.webEndpoint, nil)
	if err != nil {
		return nil, err
	}
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer utils.LogError(res.Body.Close)
	doc, err := html.Parse(res.Body)
	if err != nil {
		return nil, err
	}
	return doc, nil
}

func (rw *rewriter) getDefaultHtmlString() (string, error) {
	b := &bytes.Buffer{}
	h, err := rw.getDefaultHtml()
	if err != nil {
		return "", err
	}
	err = html.Render(b, h)
	if err != nil {
		return "", err
	}

	return b.String(), nil
}

type meta struct {
	PreventIndex  bool
	Title         string
	Description   string
	OGTitle       string
	OGDescription string
	OGUrl         string
	OGImage       string
	Favicon       string
}

func addTag(node *html.Node, tag string, attr map[string]string) {
	var attributes []html.Attribute
	for key, val := range attr {
		attributes = append(attributes, html.Attribute{
			Key: key,
			Val: val,
		})
	}
	node.AppendChild(&html.Node{
		Data: tag,
		Type: html.ElementNode,
		Attr: attributes,
	})
}

func addMetaProperty(node *html.Node, meta map[string]string) {
	addTag(node, "meta", meta)
}

func addMetaTags(n *html.Node, meta meta) {
	if n.Type == html.ElementNode && n.Data == "title" && n.Parent.Data == "head" {
		if n.FirstChild.Type == html.TextNode {
			n.FirstChild.Data = meta.Title
		}
	}
	if n.Type == html.ElementNode && n.Data == "head" {
		if meta.PreventIndex {
			addMetaProperty(n, map[string]string{
				"name":    "robots",
				"content": "noindex",
			})
		}
		addMetaProperty(n, map[string]string{
			"name":    "description",
			"content": meta.Description,
		})
		addMetaProperty(n, map[string]string{
			"property": "og:title",
			"content":  meta.OGTitle,
		})
		addMetaProperty(n, map[string]string{
			"property": "og:description",
			"content":  meta.OGTitle,
		})
		addMetaProperty(n, map[string]string{
			"property": "og:url",
			"content":  meta.OGUrl,
		})
		addMetaProperty(n, map[string]string{
			"property": "og:image",
			"content":  meta.OGImage,
		})
		addTag(n, "link", map[string]string{
			"rel":  "shortcut icon",
			"href": meta.Favicon,
			"type": "image/x-icon",
		})
	}
	for at := n.FirstChild; at != nil; at = at.NextSibling {
		addMetaTags(at, meta)
	}
}

func (rw *rewriter) writeMeta(meta meta) (string, error) {
	doc, err := rw.getDefaultHtml()
	if err != nil || doc == nil {
		return "", err
	}

	addMetaTags(doc, meta)

	b := &bytes.Buffer{}
	err = html.Render(b, doc)
	if err != nil {
		return "", err
	}

	return b.String(), nil
}

func metaForEpisode(res *episode) meta {
	e := res.Episode

	options := meta{
		Title:        e.Title,
		Description:  e.Season.Show.Title,
		PreventIndex: !e.Index,
	}

	if e.Image != nil {
		options.OGImage = *e.Image
	}

	return options
}

func metaHandler[T any](rw *rewriter, factory func(string) *T, optFactory func(*T) meta) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		res := factory(ctx.Param("id"))
		if res == nil {
			h, err := rw.getDefaultHtmlString()
			if err != nil {
				log.L.Error().Err(err).Msg("error occurred trying to retrieve default html")
			}

			ctx.Header("Content-Type", "text/html")
			ctx.String(200, h)
			return
		}

		options := optFactory(res)

		h, err := rw.writeMeta(options)
		if err != nil {
			log.L.Error().Err(err).Msg("error occurred trying to write meta to html")
		}

		ctx.Header("Content-Type", "text/html")
		ctx.String(200, h)
	}
}

func defaultHandler(rw *rewriter) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		h, err := rw.getDefaultHtmlString()
		if err != nil {
			log.L.Error().Err(err).Msg("error occurred trying to retrieve default html")
		}

		ctx.Header("Content-Type", "text/html")
		ctx.String(200, h)
		return
	}
}

func episodeHandler(rw *rewriter) gin.HandlerFunc {
	return metaHandler(rw, getEpisode, metaForEpisode)
}

type rewriter struct {
	webEndpoint string
	apiEndpoint string
}

func main() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	log.L.Debug().Msg("Setting up tracing!")

	config := getEnvConfig()

	utils.MustSetupTracing("BTV-REWRITER", config.Tracing)

	rw := &rewriter{
		apiEndpoint: config.APIEndpoint,
		webEndpoint: config.WebEndpoint,
	}

	r := gin.Default()

	r.GET("episode/:id", episodeHandler(rw))
	r.GET("episode/:id/*default", defaultHandler(rw))

	r.GET("/versionz", version.GinHandler)

	_ = r.Run(fmt.Sprintf(":%s", config.Port))
}
