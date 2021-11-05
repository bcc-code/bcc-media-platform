import { ReduxState } from "react-admin";
import { ThemeName } from "../themes";

export interface AppState extends ReduxState {
    theme: ThemeName;
}