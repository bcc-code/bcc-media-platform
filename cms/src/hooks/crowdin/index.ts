import {enabled} from "./config";
import {updateOrSetTranslationAsync} from "./source";

export type Model = "show" | "season" | "episode";
export type Collection = "shows_translations" | "seasons_translations" | "episodes_translations";

export interface Event<T> {
    key: number;
    keys: (number|string)[]
    payload: T;
    collection: Collection;
}

export default ({action, schedule}) => {
    if (!enabled()) 
        return
    
    action('items.create', updateOrSetTranslationAsync)
    action('items.update', updateOrSetTranslationAsync)

    schedule('0 0 * * *', )
}