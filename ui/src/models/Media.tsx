import { Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput } from 'react-admin';
// in src/App.js
import React from 'react';


const MediaTypes = [
    {id: 'show', name: 'Show'},
    {id: 'season', name: 'Season'},
    {id: 'episode', name: 'Episode'},
    {id: 'standalone', name: 'Standalone'},
];


export const MediaList: React.FC<ListProps> = props => (
    <List {...props}>
        <Datagrid rowClick="edit">
            <TextField source="id" />
            <TextField source="collectableType" />
            <TextField source="mediaType" />
            <NumberField source="primaryGroupID" />
            <NumberField source="subclippedMediaID" />
            <NumberField source="referenceMediaID" />
            <NumberField source="sequenceNumber" />
            <NumberField source="startTime" />
            <NumberField source="endTime" />
            <NumberField source="assetID" />
            <TextField source="agerating" />
            <DateField source="createdAt" />
            <DateField source="updatedAt" />
            <EditButton></EditButton>
        </Datagrid>
    </List>
);

export const MediEdit: React.FC<ListProps> = props => (
    <List {...props}>
        <Datagrid rowClick="edit">
            <TextField source="id" />
            <SelectInput source="mediaType" choices={MediaTypes}/>
            <TextField source="mediaType" />
            <NumberField source="primaryGroupID" />
            <NumberField source="subclippedMediaID" />
            <NumberField source="referenceMediaID" />
            <NumberField source="sequenceNumber" />
            <NumberField source="startTime" />
            <NumberField source="endTime" />
            <NumberField source="assetID" />
            <TextField source="agerating" />
            <DateField source="createdAt" />
            <DateField source="updatedAt" />
            <EditButton></EditButton>
        </Datagrid>
    </List>
);