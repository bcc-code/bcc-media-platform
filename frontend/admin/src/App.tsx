// in src/App.js
import * as React from "react";
import { Admin, EditGuesser, ListGuesser, Resource } from 'react-admin';
import { createTheme } from '@mui/material/styles';
import jsonServerProvider from 'ra-data-json-server';
import { MediaList, MediaEdit, MediaCreate } from "./resources/Medias";
import './index.css';
import { Route } from "react-router-dom";
import { MediaType } from "./types/MediaType";
import { Media } from "./types/Media";
import { Menu } from "./layout/Menu";
import * as Icons from '@mui/icons-material';
import { AssetEdit, AssetList } from "./resources/Assets";
import { ShowCreate, ShowEdit, ShowList } from "./resources/Shows";
import { SeasonCreate, SeasonEdit, SeasonList } from "./resources/Seasons";
import { EpisodeCreate, EpisodeEdit, EpisodeList } from "./resources/Episodes";
import { StandaloneCreate, StandaloneEdit, StandaloneList } from "./resources/Standalones";
import { BtvLayout } from "./layout/CustomLayout";
import themeReducer from "./configuration/themeReducer";
import { TagEdit, TagList } from "./resources/Tags";
import { PageCreate, PageEdit, PageList } from "./resources/Pages";

const dataProvider = jsonServerProvider('http://localhost:8080');
const App = () => (
    <Admin 
    layout={BtvLayout}
    customReducers={[themeReducer]}
    dataProvider={dataProvider}
    menu={Menu}>
        <Resource name="sections"></Resource>
        <Resource name="shows" list={ShowList} edit={ShowEdit} create={ShowCreate} />
        <Resource name="seasons" list={SeasonList} edit={SeasonEdit} create={SeasonCreate} />
        <Resource name="episodes" list={EpisodeList} edit={EpisodeEdit} create={EpisodeCreate} />
        <Resource name="pages" list={PageList} edit={PageEdit} create={PageCreate} />
        <Resource name="standalones" list={StandaloneList} edit={StandaloneEdit} create={StandaloneCreate} />
        <Resource name="subclips" list={MediaList} edit={MediaEdit} create={MediaCreate} />
        <Resource name="assets" list={AssetList} />
        <Resource name="medias" edit={MediaEdit} create={MediaCreate} icon={Icons.PermMedia}/>
        <Resource name="tags" edit={TagEdit} list={TagList} icon={Icons.Tag}/>
        <Resource name="asset-versions"/>
        <Resource name="usergroups" list={ListGuesser}/>
    </Admin>
);

export default App;