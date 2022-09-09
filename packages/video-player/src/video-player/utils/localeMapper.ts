export function threeLetterCodeToName(iso: string) {
    switch (iso?.toUpperCase()) {
        case "GER":
        case "DEU":
            return "Deutsch"
        case "NLD":
        case "DUT":
            return "Nederlands"
        case "NOR":
            return "Norsk"
        case "ENG":
        case "GBR":
            return "English"
        case "FRA":
        case "FRE":
            return "Français"
        case "SPA":
        case "ESP":
            return "Español"
        case "FIN":
            return "Suomi"
        case "RUS":
            return "Русский"
        case "POR":
            return "Portugese"
        case "RUM":
        case "RON":
        case "ROU":
            return "Română"
        case "TUR":
            return "Türk"
        case "POL":
            return "Polski"
        case "BUL":
            return "Български"
        case "HUN":
            return "Magyar"
        case "CZE":
        case "CES":
            return "Český"
        case "CHI":
        case "CMN":
        case "YUE":
        case "ZHS":
        case "ZHT":
            return "汉语"
        case "HRV":
            return "Hrvatski"
        case "HEB":
            return "עברית"
        case "AFR":
            return "Afrikaans"
        case "ELL":
            return "Ελληνικά"
        case "EST":
            return "Eesti"
        case "ITA":
            return "Italiano"
        case "SLV":
            return "Slovenščina"
        case "DAN":
        case "DNK":
            return "Dansk"

        default:
            return null
    }
}

export function threeLetterCodeToTwoLetterCode(iso: string) {
    switch (iso?.toUpperCase()) {
        case "GER":
        case "DEU":
            return "de"
        case "NLD":
        case "DUT":
            return "nl"
        case "NOR":
            return "no"
        case "ENG":
        case "GBR":
            return "en"
        case "FRA":
        case "FRE":
            return "fr"
        case "SPA":
        case "ESP":
            return "es"
        case "FIN":
            return "fi"
        case "RUS":
            return "ru"
        case "POR":
            return "pt"
        case "RUM":
        case "RON":
        case "ROU":
            return "ro"
        case "TUR":
            return "tk"
        case "POL":
            return "pl"
        case "BUL":
            return "bg"
        case "HUN":
            return "hu"
        case "CZE":
        case "CES":
            return "cz"
        case "CHI":
        case "CMN":
        case "YUE":
        case "ZHS":
        case "ZHT":
            return "hh"
        case "HRV":
            return "cr"
        case "HEB":
            return "he"
        case "AFR":
            return "af"
        case "ITA":
            return "it"
        case "SLV":
            return "sl"
        case "DAN":
            return "da"

        default:
            return null
    }
}

export function twoLetterCodeToThreeLetterCode(twoLetter: string) {
    switch (twoLetter?.toLowerCase()) {
        case "de":
            return "deu"
        case "nl":
            return "nld"
        case "no":
            return "nor"
        case "en":
            return "eng"
        case "fr":
            return "fra"
        case "es":
            return "spa"
        case "fi":
            return "fin"
        case "ru":
            return "rus"
        case "pt":
            return "por"
        case "ro":
            return "ron"
        case "tr":
        case "tk": //technically Turkmen not Turkish
            return "tur"
        case "pl":
            return "pol"
        case "bg":
            return "bul"
        case "hu":
            return "hun"
        case "cs":
        case "cz": //technically incorrect
            return "ces"
        case "zh":
            return "chi"
        case "hr":
            return "hrv"
        case "he":
            return "heb"
        case "af":
            return "afr"
        case "it":
            return "ita"
        case "sl":
            return "slv"
        case "da":
            return "dan"

        default:
            return "und"
    }
}
