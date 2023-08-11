package utils

import "github.com/bcc-code/mediabank-bridge/log"

var langMap = map[string]string{
	"nor":       "no",
	"nob":       "no",
	"no-x":      "nb",
	"no-x-tolk": "nb",
	"dan":       "da",
	"dnk":       "da",
	"deu":       "de",
	"ger":       "de",
	"nld":       "nl",
	"dut":       "nl",
	"eng":       "en",
	"fra":       "fr",
	"fre":       "fr",
	"spa":       "es",
	"esp":       "es",
	"fin":       "fi",
	"rus":       "ru",
	"por":       "pt",
	"ron":       "ro",
	"rum":       "ro",
	"rou":       "ro",
	"tk":        "tr",
	"tur":       "tr",
	"pol":       "pl",
	"bul":       "bg",
	"hun":       "hu",
	"ita":       "it",
	"slv":       "sl",
	"swe":       "sv",
	"cmn":       "zh",
	"zho":       "zh",
	"chi":       "zh",
	"zht":       "zh",
	"hrv":       "hr",
	"hbs-hrv":   "hr",
	"tam":       "ta",
	"kha":       "kha",
	"yue":       "yue",
}

// LegacyLanguageCodeTo639_1 converts language codes used in the legacy system and
// the smil file to proper ISO 639-1 codes as used in our DB
func LegacyLanguageCodeTo639_1(code string) string {

	if twoLetterCode, ok := langMap[code]; ok {
		return twoLetterCode
	}

	log.L.Warn().Str("code", code).Msg("Unknown language code, please fix")
	return ""
}
