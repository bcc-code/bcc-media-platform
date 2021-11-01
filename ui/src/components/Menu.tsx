// in src/Menu.js
import React from 'react';
import { DashboardMenuItem, MenuItemLink } from 'react-admin';
import { Book as BookIcon} from '@material-ui/icons';
import { MediaType } from '../models/MediaType';

export const Menu = () => (
    <div className="mt-6">
        <DashboardMenuItem />
        <MenuItemLink to="/medias" primaryText="All" leftIcon={<BookIcon />}/>
        <MenuItemLink to={{ pathname: "/medias", search: "mediaType=" + MediaType.Standalone }} primaryText="Standalones" leftIcon={<BookIcon />}/>
        <MenuItemLink to={{ pathname: "/medias", search: "mediaType=" + MediaType.Show }} primaryText="Shows" leftIcon={<BookIcon />}/>
        <MenuItemLink to={{ pathname: "/medias", search: "mediaType=" + MediaType.Season }} primaryText="Seasons" leftIcon={<BookIcon />}/>
        <MenuItemLink to={{ pathname: "/medias", search: "mediaType=" + MediaType.Episode }} primaryText="Episodes" leftIcon={<BookIcon />}/>
        <MenuItemLink to="/categories" primaryText="Categories" leftIcon={<BookIcon />}/>
        <MenuItemLink to="/assets" primaryText="Assets" leftIcon={<BookIcon />}/>
    </div>
);