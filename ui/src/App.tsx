// in src/App.js
import * as React from "react";
import { Admin, EditGuesser, Resource } from 'react-admin';
import jsonServerProvider from 'ra-data-json-server';
import { MediaList, MediaEdit, MediaCreate } from "./resources/Media";
import './index.css';

const dataProvider = jsonServerProvider('http://localhost:8080');
const App = () => (
    <Admin dataProvider={dataProvider}>
        <Resource name="medias" list={MediaList} edit={MediaEdit} create={MediaCreate} />
    </Admin>
);

export default App;