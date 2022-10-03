package main

import (
	"bytes"
	"fmt"
	"github.com/gin-gonic/gin"
	"golang.org/x/net/html"
	"log"
	"net/http"
)

func (rw *rewriter) getDefaultHtml() *html.Node {
	req, _ := http.NewRequest("GET", rw.webEndpoint, nil)
	res, _ := http.DefaultClient.Do(req)

	doc, _ := html.Parse(res.Body)
	return doc
}

func (rw *rewriter) getDefaultHtmlString() string {
	b := &bytes.Buffer{}
	_ = html.Render(b, rw.getDefaultHtml())

	return b.String()
}

type meta struct {
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

func (rw *rewriter) writeMeta(meta meta) string {
	doc := rw.getDefaultHtml()

	var f func(*html.Node)
	f = func(n *html.Node) {
		if n.Type == html.ElementNode && n.Data == "title" && n.Parent.Data == "head" {
			if n.FirstChild.Type == html.TextNode {
				n.FirstChild.Data = "BrunstadTV - " + meta.Title
			}
		}
		if n.Type == html.ElementNode && n.Data == "head" {
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
			f(at)
		}
	}

	f(doc)

	b := &bytes.Buffer{}
	_ = html.Render(b, doc)

	return b.String()
}

type rewriter struct {
	webEndpoint string
	apiEndpoint string
}

func main() {
	config := getEnvConfig()

	rw := &rewriter{
		apiEndpoint: config.APIEndpoint,
		webEndpoint: config.WebEndpoint,
	}

	r := gin.Default()

	r.GET("episodes/:id", func(ctx *gin.Context) {
		res := getEpisode(ctx.Param("id"))

		if res == nil {
			ctx.Header("Content-Type", "text/html")
			ctx.String(200, rw.getDefaultHtmlString())
			return
		}

		e := res.Episode

		log.Default().Print(res)

		options := meta{
			Title:       e.Title,
			Description: e.Description,
		}
		if e.Image != nil {
			options.OGImage = *e.Image
		}

		h := rw.writeMeta(options)

		ctx.Header("Content-Type", "text/html")
		ctx.String(200, h)
	})

	r.GET("seasons/:id", func(ctx *gin.Context) {
		res := getSeason(ctx.Param("id"))

		if res == nil {
			ctx.Header("Content-Type", "text/html")
			ctx.String(200, rw.getDefaultHtmlString())
			return
		}

		e := res.Season

		options := meta{
			Title:       e.Title,
			Description: e.Description,
		}
		if e.Image != nil {
			options.OGImage = *e.Image
		}

		ctx.Header("Content-Type", "text/html")
		ctx.String(200, rw.writeMeta(options))
	})

	r.GET("shows/:id", func(ctx *gin.Context) {
		res := getShow(ctx.Param("id"))

		if res == nil {
			ctx.Header("Content-Type", "text/html")
			ctx.String(200, rw.getDefaultHtmlString())
			return
		}

		e := res.Show

		options := meta{
			Title:       e.Title,
			Description: e.Description,
		}
		if e.Image != nil {
			options.OGImage = *e.Image
		}

		h := rw.writeMeta(options)

		ctx.Header("Content-Type", "text/html")
		ctx.String(200, h)
	})

	_ = r.Run(fmt.Sprintf(":%s", config.Port))
}
