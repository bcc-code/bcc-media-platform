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
        return action.payload;
    }
    return previousState;
};

export default themeReducer;