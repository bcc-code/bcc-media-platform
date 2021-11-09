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
import { ShowCreate, ShowEdit, ShowList } from "./resources/Show";
import { SeasonCreate, SeasonEdit, SeasonList } from "./resources/Season";
import { EpisodeCreate, EpisodeEdit, EpisodeList } from "./resources/Episode";
import { StandaloneCreate, StandaloneEdit, StandaloneList } from "./resources/Standalone";
import { BtvLayout } from "./layout/CustomLayout";
import themeReducer from "./configuration/themeReducer";
import { TagEdit, TagList } from "./resources/Tags";

const dataProvider = jsonServerProvider('http://localhost:8080');
const App = () => (
    <Admin 
    layout={BtvLayout}
    customReducers={[themeReducer]}
    dataProvider={dataProvider}
    menu={Menu}>
        <Resource name="show" list={ShowList} edit={ShowEdit} create={ShowCreate} />
        <Resource name="season" list={SeasonList} edit={SeasonEdit} create={SeasonCreate} />
        <Resource name="episode" list={EpisodeList} edit={EpisodeEdit} create={EpisodeCreate} />
        <Resource name="standalone" list={StandaloneList} edit={StandaloneEdit} create={StandaloneCreate} />
        <Resource name="subclip" list={MediaList} edit={MediaEdit} create={MediaCreate} />
        <Resource name="assets" list={AssetList} />
        <Resource name="media" edit={MediaEdit} create={MediaCreate} icon={Icons.PermMedia}/>
        <Resource name="tags" edit={TagEdit} list={TagList} icon={Icons.Tag}/>
        <Resource name="asset-versions"/>
        <Resource name="usergroups" list={ListGuesser}/>
    </Admin>
);

export default App;