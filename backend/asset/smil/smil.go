package smil

// https://www.w3.org/TR/SMIL2/

import (
	"encoding/xml"
)

// Meta data for the SMIL file in general
type Meta struct {
	XMLName xml.Name `xml:"meta"`
	Name    string   `xml:"name,attr"`
	Content string   `xml:"content,attr"`
}

// Head of the SMIL file, mostly for overall metadata
type Head struct {
	XMLName xml.Name `xml:"head"`
	Meta    []Meta   `xml:"meta"`
}

// Body of the smil file
type Body struct {
	XMLName xml.Name `xml:"body"`
	Switch  Switch   `xml:"switch"`
}

// Switch element allows an author to specify a set of alternative elements from which only the first acceptable element is chosen.
// ^^ Above is copy pasted from https://www.w3.org/TR/SMIL2/smil-content.html#edef-switch
// Basically it's a wrapper saying everything in here is the same material in different formats
type Switch struct {
	XMLName xml.Name     `xml:"switch"`
	Videos  []Video      `xml:"video"`
	Audios  []Audio      `xml:"audio"`
	Subs    []Textstream `xml:"textstream"`
}

// Video source
type Video struct {
	XMLName        xml.Name `xml:"video"`
	Src            string   `xml:"src,attr"`
	IncludeAudio   string   `xml:"includeAudio,attr"`
	SystemLanguage string   `xml:"systemLanguage,attr"`
	AudioName      string   `xml:"audioName,attr"`
}

// Audio source
type Audio struct {
	XMLName xml.Name `xml:"audio"`
	Src     string   `xml:"src,attr"`
	Params  []Param  `xml:"param"`
}

// Textstream it the subtitle source
type Textstream struct {
	XMLName        xml.Name `xml:"textstream"`
	Src            string   `xml:"src,attr"`
	SystemLanguage string   `xml:"systemLanguage,attr"`
	SubtitleName   string   `xml:"subtitleName,attr"`
}

// Param contains additional informaion for Audio, Video, Text such as
// resolution, language, etc.
type Param struct {
	XMLName   xml.Name `xml:"param"`
	Name      string   `xml:"name,attr"`
	Value     string   `xml:"value,attr"`
	ValueType string   `xml:"valuetype,attr"`
}

// Main is the base SMIL struct
type Main struct {
	XMLName xml.Name `xml:"smil"`
	Head    Head     `xml:"head"`
	Body    Body     `xml:"body"`
}

// Unmarshall a XML file in smil format
func Unmarshall(data []byte) (Main, error) {
	var x Main
	err := xml.Unmarshal(data, &x)
	return x, err
}
