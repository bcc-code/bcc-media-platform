export const lanTo3letter: {
    [key: string]: string
} = {
    no: 'nor',
    en: 'eng',
    nl: 'nld',
    de: 'deu',
    fr: 'fra',
    es: 'spa',
    fi: 'fin',
    ru: 'rus',
    pt: 'por',
    ro: 'ron',
    tr: 'tur',
    pl: 'pol',
    hu: 'hun',
    it: 'ita',
    da: 'dan',
}

export const languageTo3letter = (language: string) => {
    return lanTo3letter[language] ?? language
}
