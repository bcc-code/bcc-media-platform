// in src/App.js
import * as React from "react";
import { Admin, EditGuesser, Resource } from 'react-admin';
import jsonServerProvider from 'ra-data-json-server';
import { MediaList, MediaEdit } from "./models/Media";

const dataProvider = jsonServerProvider('http://localhost:8080');
const App = () => (
    <Admin dataProvider={dataProvider}>
        <Resource name="medias" list={MediaList} edit={EditGuesser}/>
    </Admin>
);

export default App;