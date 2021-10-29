import { Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput, ReferenceInput, SelectArrayInput, ReferenceField, FormDataConsumer, SimpleFormView, TabbedForm, Tab, FormTab, FormWithRedirect, DateTimeInput, ReferenceManyField, ArrayField, useWarnWhenUnsavedChanges, Toolbar } from 'react-admin';
// in src/App.js
import React from 'react';
import { AgeRatingChoices } from '../models/AgeRating';
import { Chip } from '@mui/material';


const MediaTypes = [
    {id: 'show', name: 'Show'},
    {id: 'season', name: 'Season'},
    {id: 'episode', name: 'Episode'},
    {id: 'standalone', name: 'Standalone'},
    {id: 'subclip', name: 'Subclip'},
    {id: 'marker', name: 'Marker'},
];

function getParentType(mediaType: string): string {
    switch(mediaType){
        case "standalone": return "Season"
        case "episode": return "Season"
        case "season": return "Show"
        default: return ""
    }
}


export const MediaList: React.FC<ListProps> = props => (
    <List {...props} filter={{mediaType: "show"}}>
        <Datagrid rowClick="edit">
            <TextField source="id" />
            <TextField source="collectableType" />
            <TextField source="mediaType" />
            <TextField source="title" />
            <TextField source="description" />
            <ReferenceField source="referenceMediaID" reference="medias" label="Reference media">
                <TextField source="title"/>
            </ReferenceField>
            <ReferenceField source="primaryGroupID" reference="medias" label="Parent media">
                <TextField source="title"/>
            </ReferenceField>
            <NumberField source="subclippedMediaID" />
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
        <FormWithRedirect warnWhenUnsavedChanges render={formProps =>
            <form>
                <div className="p-4 flex flex-col">
                    <div className='text-sm'>#{formProps.record?.id} <span className="capitalize">{formProps.record?.mediaType}</span></div>
                    <TextField source="title" variant='h6'/>
                    <div>
                    <div className="bg-gray-100 p-2 rounded my-2 text-sm">
                        <span className=" -sm">Created</span> <DateField source="createdAt" showTime />
                        &nbsp;| <span className=" ">Last updated </span> <DateField source="updatedAt" showTime />
                    </div></div>
                    <TextInput source="title" />
                    <TextInput source="description" />
                    <TextInput source="longDescription" />
                    <SelectInput source="mediaType" choices={MediaTypes}/>
                    <NumberInput source="sequenceNumber" />
                    <FormDataConsumer>
                        {({formData}) => formData.mediaType === "subclip" &&
                            <>
                                <h4 style={{textTransform: "capitalize"}}>Subclip settings</h4>
                                <ReferenceInput source="subclippedMediaID" reference="medias" label='Subclipped media'>
                                    <SelectInput optionText="title" />
                                </ReferenceInput>
                                <NumberInput source="startTime" />
                                <NumberInput source="endTime" />
                            </>
                        }
                    </FormDataConsumer>
                    <SelectInput source="agerating" choices={AgeRatingChoices}/>
                    
                    <ReferenceInput source="primaryGroupID" reference="medias" label={getParentType(formProps.record?.mediaType)}>
                        <SelectInput optionText="title" />
                    </ReferenceInput>
                    <NumberInput source="assetID" />
                    
                    <SaveButton
                    saving={formProps.saving}
                    disabled={formProps.pristine}
                    handleSubmitWithRedirect={formProps.handleSubmitWithRedirect}/>
                    <div className="mt-2">
                        Child media
                        <ReferenceManyField label="Child media" reference="medias" target="primaryGroupID">
                            <ArrayField>
                                <Datagrid>
                                    <TextField source="id" />
                                    <TextField source="collectableType" />
                                    <TextField source="mediaType" />
                                    <TextField source="title" />
                                    <TextField source="description" />
                                    <EditButton/>
                                </Datagrid>
                            </ArrayField>
                        </ReferenceManyField>
                        
                    </div>
                </div>
            </form>
        }/>
    </Edit>
);

export const MediaCreate: React.FC<CreateProps> = props => (
    <Create {...props}>
        <FormWithRedirect warnWhenUnsavedChanges render={formProps =>
            <form>
                <div className="p-4 flex flex-col">
                    <TextField source="title" variant='h6'/>
                    <TextInput source="title" />
                    <TextInput source="description" />
                    <TextInput source="longDescription" />
                    <SelectInput source="mediaType" choices={MediaTypes}/>
                    <NumberInput source="sequenceNumber" />
                    <FormDataConsumer>
                        {({formData}) => formData.mediaType === "subclip" &&
                            <>
                                <h4 style={{textTransform: "capitalize"}}>Subclip settings</h4>
                                <ReferenceInput source="subclippedMediaID" reference="medias" label='Subclipped media'>
                                    <SelectInput optionText="title" />
                                </ReferenceInput>
                                <NumberInput source="startTime" />
                                <NumberInput source="endTime" />
                            </>
                        }
                    </FormDataConsumer>
                    <SelectInput source="agerating" choices={AgeRatingChoices}/>
                    
                    <ReferenceInput source="primaryGroupID" reference="medias" label={getParentType(formProps.record?.mediaType)}>
                        <SelectInput optionText="title" />
                    </ReferenceInput>
                    <NumberInput source="assetID" />
                    <DateField source="createdAt" showTime />
                    <DateField source="updatedAt" showTime />
                    <Toolbar>
                        <SaveButton
                        saving={formProps.saving}
                        handleSubmitWithRedirect={formProps.handleSubmitWithRedirect}/>
                    </Toolbar>
                </div>
            </form>
        }/>
    </Create>
);