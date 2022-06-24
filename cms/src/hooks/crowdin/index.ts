import {enabled} from "./config";
import {updateOrSetTranslationAsync} from "./source";
import { sync } from "./sync";

export type Model = "show" | "season" | "episode";
export type Collection = "shows_translations" | "seasons_translations" | "episodes_translations";

export interface Event<T> {
    key: number;
    keys: (number|string)[]
    payload: T;
    collection: Collection;
}

export default ({action, schedule, init}) => {
    if (!enabled()) 
        return
    
    action('items.create', updateOrSetTranslationAsync)
    action('items.update', updateOrSetTranslationAsync)

    schedule('0 * * * *', sync)
    // init('app.after', sync)
}

export function getPrimaryLanguageKey() {
    return process.env.CROWDIN_PRIMARY_LANGUAGE
}