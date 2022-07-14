package utils

import "github.com/bcc-code/mediabank-bridge/log"

// LegacyLanguageCodeTo639_1 converts language codes used in the legacy system and
// the smil file to proper ISO 639-1 codes as used in our DB
func LegacyLanguageCodeTo639_1(code string) string {

	switch code {
	case "nor":
		return "no"
	case "no-x":
	case "no-x-tolk":
		return "nb"
	case "dan":
	case "dnk":
		return "da"
	case "deu":
	case "ger":
		return "de"
	case "nld":
	case "dut":
		return "nl"
	case "eng":
		return "en"
	case "fra":
	case "fre":
		return "fr"
	case "spa":
	case "esp":
		return "es"
	case "fin":
		return "fi"
	case "rus":
		return "ru"
	case "por":
		return "pt"
	case "ron":
	case "rum":
	case "rou":
		return "ro"
	case "tk":
	case "tur":
		return "tr"
	case "pol":
		return "pl"
	case "bul":
		return "bg"
	case "hun":
		return "hu"
	case "ita":
		return "it"
	case "slv":
		return "sl"
	case "zho":
	case "chi":
	case "zht":
		return "zh"
	case "hrv":
	case "hbs-hrv":
		return "hr"
	}

	log.L.Warn().Str("code", code).Msg("Unknown language code, please fix")
	return ""
}
