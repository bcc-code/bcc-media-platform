import {Event, Model} from ".";


type LanguagesCode = {
    code: string;
}

type Translation = {
    title: string;
    description: string;
    languages_code: LanguagesCode;
}

type TranslationPayloads = {
    show: Translation & {shows_id: number;};
    season: Translation & {seasons_id: number;};
    episode: Translation & {episodes_id: number; extra_description: string;};
}

type TranslationPayload<S extends Model> = TranslationPayloads[S]

export function getTranslationsFromEvent(input: Event<any>) {
    const payload = input.payload as Translation;
    let model: Model;
    let id: number;

    const values: {
        [key: string]: string;
    } = {}

    if (payload.title)
        values.title = payload.title;
    if (payload.description)
        values.description = payload.description;

    switch (input.collection) {
        case "shows_translations":
            model = "show"
            id = (payload as TranslationPayload<"show">).shows_id
            break;
        case "seasons_translations":
            model = "season"
            id = (payload as TranslationPayload<"season">).seasons_id
            break;
        case "episodes_translations":
            model = "episode"
            id = (payload as TranslationPayload<"episode">).episodes_id
            let extraDescription = (payload as TranslationPayload<"episode">).extra_description
            if (extraDescription)
                values.extra_description = extraDescription
            break;
        default:
            return;
    }

    return {
        model,
        id,
        values,
    }
}