// in src/App.js
import * as React from "react";
import { Admin, createMuiTheme, EditGuesser, ListGuesser, Resource } from 'react-admin';
import jsonServerProvider from 'ra-data-json-server';
import { MediaListWithFilter, MediaEdit, MediaCreate } from "./resources/Medias";
import './index.css';
import { ThemeProvider } from "@mui/material";
import { Route } from "react-router-dom";
import { MediaType } from "./models/MediaType";
import { Media } from "./models/Media";
import Menu from "./components/Menu";
import { AssetEdit, AssetList } from "./resources/Assets";
const baseTheme = createMuiTheme();

const dataProvider = jsonServerProvider('http://localhost:8080');
const App = () => (
    <ThemeProvider theme={baseTheme}>
        <Admin 
        dataProvider={dataProvider}
        customRoutes={[
            <Route exact path="/shows" render={MediaListWithFilter({mediaType: MediaType.Show})} />,
            <Route exact path="/seasons" render={MediaListWithFilter({mediaType: "season"})} />,
            <Route exact path="/episodes" render={MediaListWithFilter({mediaType: "episode"})} />,
            <Route exact path="/standalones" render={MediaListWithFilter({mediaType: "standalone"})} />,
        ]}
        menu={Menu}>
            <Resource name="medias" list={MediaListWithFilter(undefined)} edit={MediaEdit} create={MediaCreate} />
            <Resource name="assets" list={AssetList} edit={AssetEdit} />
            <Resource name="asset-versions" list={ListGuesser} edit={EditGuesser} />
        </Admin>
    </ThemeProvider>
);

export default App;