import { Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput } from 'react-admin';
// in src/App.js
import React from 'react';
import { AgeRatingChoices } from '../models/AgeRating';


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
            <TextField source="title" />
            <TextField source="description" />
            <NumberField source="primaryGroupID" />
            <NumberField source="subclippedMediaID" />
            <NumberField source="referenceMediaID" />
            <NumberField source="sequenceNumber" />
            <NumberField source="startTime" />
            <NumberField source="endTime" />
            <NumberField source="assetID" />
            <DateField source="createdAt" />
            <DateField source="updatedAt" />
            <EditButton/>
        </Datagrid>
    </List>
);

export const MediaEdit: React.FC<EditProps> = props => (
    <Edit {...props}>
        <SimpleForm>
            <TextField source="id" />
            <SelectInput source="mediaType" choices={MediaTypes}/>
            <TextInput source="mediaType" />
            <NumberInput source="sequenceNumber" />
            <TextInput source="title" />
            <TextInput source="description" />
            <TextInput source="longDescription" />
            <NumberInput source="referenceMediaID" />
            <NumberInput source="startTime" />
            <NumberInput source="endTime" />
            <SelectInput source="agerating" choices={AgeRatingChoices}/>
            <NumberInput source="primaryGroupID" />
            <NumberInput source="subclippedMediaID" />
            <NumberInput source="assetID" />
            <DateField source="createdAt" />
            <DateField source="updatedAt" />
        </SimpleForm>
    </Edit>
);

export const MediaCreate: React.FC<CreateProps> = props => (
    <Create {...props}>
        <SimpleForm>
            <TextField source="id" />
            <SelectInput source="mediaType" choices={MediaTypes}/>
            <TextInput source="mediaType" />
            <NumberInput source="sequenceNumber" />
            <TextInput source="title" />
            <TextInput source="description" />
            <TextInput source="longDescription" />
            <NumberInput source="referenceMediaID" />
            <NumberInput source="startTime" />
            <NumberInput source="endTime" />
            <SelectInput source="agerating" choices={AgeRatingChoices}/>
            <NumberInput source="primaryGroupID" />
            <NumberInput source="subclippedMediaID" />
            <NumberInput source="assetID" />
            <DateField source="createdAt" />
            <DateField source="updatedAt" />
        </SimpleForm>
    </Create>
);