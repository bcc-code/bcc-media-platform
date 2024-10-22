export const languageTo3letter = (language: string) => {
    switch (language) {
        // Norwegian
        case 'no':
        case 'nb':
        case 'nor':
        case 'nob':
        case 'no-nob':
            return 'nor';

        // English
        case 'en':
        case 'eng':
            return 'eng';

        // French
        case 'fr':
        case 'fra':
            return 'fra';

        // German
        case 'de':
        case 'deu':
            return 'deu';

        // Hungarian
        case 'hu':
        case 'hun':
            return 'hun';

        // Spanish
        case 'es':
        case 'spa':
            return 'spa';

        // Italian
        case 'it':
        case 'ita':
            return 'ita';

        // Polish
        case 'pl':
        case 'pol':
            return 'pol';

        // Romanian
        case 'ro':
        case 'ron':
            return 'ron';

        // Russian
        case 'ru':
        case 'rus':
            return 'rus';

        // Slovenian
        case 'sl':
        case 'slv':
            return 'slv';

        // Turkish
        case 'tr':
        case 'tur':
            return 'tur';

        // Chinese
        case 'zh':
        case 'zho':
        case 'cmn':
        case 'zh-cmn':
            return 'zho';

        // Cantonese
        case 'zh-HK':
        case 'yue':
            return 'yue';

        // Tamil
        case 'ta':
        case 'tam':
            return 'tam';

        // Bulgarian
        case 'bg':
        case 'bul':
            return 'bul';

        // Netherlands
        case 'nl':
        case 'nld':
            return 'nld';

        // Danish
        case 'da':
        case 'dan':
            return 'dan';

        // Finnish
        case 'fi':
        case 'fin':
            return 'fin';

        // Portuguese
        case 'pt':
        case 'por':
            return 'por';

        // Khasi
        case 'kha':
            return 'kha';

        // Croatian
        case 'hr':
        case 'hrv':
        case 'hbs-hrv':
            return 'hrv';

        default:
            return language;
    }
}
