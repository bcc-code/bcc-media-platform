package main

import (
	"bytes"
	"github.com/gin-gonic/gin"
	"golang.org/x/net/html"
	"log"
	"net/http"
)

func getDefaultHtml() *html.Node {
	req, _ := http.NewRequest("GET", "https://web.brunstad.tv", nil)
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
	Favicon       string
}

func rewrite() string {
	doc := getDefaultHtml()
	var f func(*html.Node)
	f = func(n *html.Node) {
		if n.Type == html.ElementNode && n.Data == "head" {
			n.AppendChild(&html.Node{
				Data: "meta",
				Type: html.ElementNode,
				Attr: []html.Attribute{
					{
						Key: "name",
						Val: "Test",
					},
				},
			})
		} else {
			for at := n.FirstChild; at != nil; at = at.NextSibling {
				f(at)
			}
		}
	}

	f(doc)

	buf := &bytes.Buffer{}

	_ = html.Render(buf, doc)

	return buf.String()
}

func writeMeta(meta meta) {
	doc := getDefaultHtml()
	var f func(*html.Node)
	f = func(n *html.Node) {
		if n.Type == html.ElementNode && n.Data == "head" {
			n.AppendChild(&html.Node{
				Data: "meta",
				Type: html.ElementNode,
				Attr: []html.Attribute{
					{
						Key: "name",
						Val: "Test",
					},
				},
			})
		} else {
			for at := n.FirstChild; at != nil; at = at.NextSibling {
				f(at)
			}
		}
	}

	f(doc)
}

func main() {
	r := gin.Default()

	log.Default().Print(getDefaultHtml())

	r.GET("episodes/:id", func(ctx *gin.Context) {

	})
}
