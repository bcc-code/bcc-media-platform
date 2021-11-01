// in src/App.js
import * as React from "react";
import { Admin, createMuiTheme, EditGuesser, Resource } from 'react-admin';
import jsonServerProvider from 'ra-data-json-server';
import { MediaList, MediaEdit, MediaCreate } from "./resources/Media";
import './index.css';
import { ThemeProvider } from "@mui/material";
import { Route } from "react-router-dom";
import { MediaType } from "./models/MediaType";
import { Media } from "./models/Media";
import { Menu } from "./components/Menu";
const baseTheme = createMuiTheme();

const dataProvider = jsonServerProvider('http://localhost:8080');
const App = () => (
    <ThemeProvider theme={baseTheme}>
        <Admin 
        dataProvider={dataProvider}
        menu={Menu}>
            <Resource name="medias" list={MediaList} edit={MediaEdit} create={MediaCreate} />
        </Admin>
    </ThemeProvider>
);

export default App;