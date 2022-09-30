package main

import (
	"bytes"
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

	log.Default().Print(rw.writeMeta(meta{
		Title: "OIOIOIS",
	}))

	r.GET("episodes/:id", func(ctx *gin.Context) {

	})
}
