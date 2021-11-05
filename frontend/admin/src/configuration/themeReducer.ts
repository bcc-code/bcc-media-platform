import { Reducer } from 'redux';
import { CHANGE_THEME, changeTheme } from './actions';
import { ThemeName } from '../themes';

type Action =
    | ReturnType<typeof changeTheme>
    | { type: 'OTHER_ACTION'; payload?: any };

const themeReducer: Reducer<ThemeName, Action> = (
    previousState = 'dark',
    action
) => {
    if (action.type === CHANGE_THEME) {
        if (action.payload == "dark"){
            document.getElementById("body")?.classList.add("dark");
            document.getElementById("body")?.classList.remove("light");
        } else {
            document.getElementById("body")?.classList.remove("dark");
            document.getElementById("body")?.classList.add("light");
        }
        return action.payload;
    }
    return previousState;
};

export default themeReducer;