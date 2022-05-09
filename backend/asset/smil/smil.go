package smil

import (
	"encoding/xml"

	"github.com/davecgh/go-spew/spew"
)

type Meta struct {
	XMLName xml.Name `xml:"meta"`
	Name    string   `xml:"name,attr"`
	Content string   `xml:"content,attr"`
}

type Head struct {
	XMLName xml.Name `xml:"head"`
	Meta    []Meta   `xml:"meta"`
}

type Body struct {
	XMLName xml.Name `xml:"body"`
	Switch  Switch   `xml:"switch"`
}

type Switch struct {
	XMLName xml.Name `xml:"switch"`
	Videos  []Video  `xml:"video"`
	Audios  []Audio  `xml:"audio"`
}

type Video struct {
	XMLName xml.Name `xml:"video"`
	Src     string   `xml:"src,attr"`
}

type Audio struct {
	XMLName xml.Name `xml:"audio"`
	Src     string   `xml:"src,attr"`
	Params  []Param  `xml:"param"`
}

type Param struct {
	XMLName   xml.Name `xml:"param"`
	Name      string   `xml:"name,attr"`
	Value     string   `xml:"value,attr"`
	ValueType string   `xml:"valuetype,attr"`
}

type Main struct {
	XMLName xml.Name `xml:"smil"`
	Head    Head     `xml:"head"`
	Body    Body     `xml:"body"`
}

func parse(data []byte) error {
	var x Main
	err := xml.Unmarshal(data, &x)
	spew.Dump(x)
	return err
}
