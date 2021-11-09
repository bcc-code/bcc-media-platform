import { Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput, ReferenceInput, SelectArrayInput, ReferenceField, FormDataConsumer, SimpleFormView, TabbedForm, Tab, FormTab, FormWithRedirect, DateTimeInput, ReferenceManyField, ArrayField, useWarnWhenUnsavedChanges, Toolbar, Link, TopToolbar, CreateButton, ExportButton, Button, ReferenceArrayInput } from 'react-admin';
// in src/App.js
import React, { cloneElement } from 'react';
import { AgeRatingChoices } from '../types/AgeRating';
import ContentAdd from '@mui/icons-material/Add';
import { useLocation } from 'react-router-dom';
import { Media } from '../types/Media';
import { MediaType } from '../types/MediaType';
import { Box } from '@mui/material';

const MediaTypes = [
    {id: 'show', name: 'Show'},
    {id: 'season', name: 'Season'},
    {id: 'episode', name: 'Episode'},
    {id: 'standalone', name: 'Standalone'},
    {id: 'subclip', name: 'Subclip'},
    {id: 'marker', name: 'Marker'},
];

function getParentType(mediaType: string): MediaType | undefined {
    switch (mediaType) {
        case "standalone": return undefined
        case "episode": return MediaType.Season
        case "season": return MediaType.Show
        case "show": return undefined
        default: return undefined
    }
}

function getChildType(mediaType: string): MediaType | undefined {
    switch (mediaType){
        case "standalone": return undefined
        case "episode": return undefined
        case "season": return MediaType.Episode
        case "show": return MediaType.Season
        default: return undefined
    }
}

const ListActions = () => (
    <TopToolbar>
        <CreateButton/>
        <ExportButton/>
    </TopToolbar>
);  

export const MediaList: React.FC<ListProps> = props => {
    const parentType = getParentType(props.resource!)
    return (
        <List actions={<ListActions/>} {...props} filters={[
            <TextInput sx={{mb:2}} size='small' label="Search" source="q" alwaysOn />
        ]}>
            <Datagrid rowClick="edit">
                <TextField source="mediaType" />
                <TextField source="title" />
                <TextField source="description" />
                { parentType != null &&
                    <ReferenceField source="primaryGroupID" reference={parentType!} label="Parent media">
                        <TextField source="title"/>
                    </ReferenceField>
                }
                <NumberField source="sequenceNumber" />
                {props.resource == 'media' &&
                    <ReferenceField source="referenceMediaID" reference={props.resource!} label="Reference media">
                        <TextField source="title"/>
                    </ReferenceField>
                }
                <DateField source="createdAt" />
                <DateField source="updatedAt" />
            </Datagrid>
        </List>
    );
};

export const MediaEdit: React.FC<EditProps> = props => {
    return (
        <Edit {...props} undoable={false}>
            <FormWithRedirect warnWhenUnsavedChanges render={formProps =>
                <form>
                   <Box sx={{p:4,display:'flex',flexDirection:'column',width:{xs: '100%', lg: '66%', xl: '50%'}}}>
                        <div className='text-sm'>#{formProps.record?.id} <span className="capitalize">{formProps.record?.mediaType}</span></div>
                        <TextField source="title" variant='h6'/>
                        <Box sx={{ backgroundColor: 'background.paper', color: 'text.secondary', padding: '10px', borderRadius: '10px' }}>
                            <span>Created</span> <DateField source="createdAt" showTime />
                            &nbsp;| <span>Last updated </span> <DateField source="updatedAt" showTime />
                        </Box>
                        <TextInput source="title" />
                        <TextInput source="description" />
                        <TextInput source="longDescription" />
                        <NumberInput source="sequenceNumber" />
                        <FormDataConsumer>
                            {({formData}) => formData.mediaType === "subclip" &&
                                <>
                                    <h4 style={{textTransform: "capitalize"}}>Subclip settings</h4>
                                    <ReferenceInput source="subclippedMediaID" reference="media" label='Subclipped media'>
                                        <SelectInput optionText="title" />
                                    </ReferenceInput>
                                    <NumberInput source="startTime" />
                                    <NumberInput source="endTime" />
                                </>
                            }
                        </FormDataConsumer>
                        <SelectInput source="agerating" choices={AgeRatingChoices}/>
                        
                        <ReferenceInput source="primaryGroupID" reference="media" label={getParentType(formProps.record?.mediaType)}>
                            <SelectInput optionText="title" />
                        </ReferenceInput>
                        <NumberInput source="assetID" />

                        <ReferenceArrayInput source="usergroups" reference="usergroups">
                            <SelectArrayInput optionText="id" />
                        </ReferenceArrayInput>
                        <ReferenceArrayInput source="tags" reference="tags">
                            <SelectArrayInput optionText={(r) => r.title ?? "Error: no title"} />
                        </ReferenceArrayInput>

                        <SaveButton
                        saving={formProps.saving}
                        disabled={formProps.pristine}
                        handleSubmitWithRedirect={formProps.handleSubmitWithRedirect}/>

                        <div className="mt-4">
                            <h4>Child media</h4>
                            <Link to={{
                                pathname: "/media/create",
                                state: { initialValues: { primaryGroupID: formProps.record?.id, mediaType: getChildType(formProps.record?.mediaType) } }
                            }}>
                                <button type="button">
                                    <ContentAdd />Create {getChildType(formProps.record?.mediaType)}
                                </button>
                            </Link>
                            <ReferenceManyField label="Child media" reference="media" target="primaryGroupID">
                                <ArrayField>
                                    <Datagrid rowClick="edit">
                                        <TextField source="id" />
                                        <TextField source="collectableType" />
                                        <TextField source="mediaType" />
                                        <TextField source="title" />
                                        <TextField source="description" />
                                    </Datagrid>
                                </ArrayField>
                            </ReferenceManyField>
                        </div>
                    </Box>
                </form>
            }/>
        </Edit>
    )
};

export const MediaCreate: React.FC<CreateProps> = props => {
    const location = useLocation<{initialValues: Media}>();
    return (
    <Create {...props}>
        <FormWithRedirect warnWhenUnsavedChanges initialValues={location.state?.initialValues} render={formProps =>
            <form>
               <Box sx={{p:4,display:'flex',flexDirection:'column',width:{xs: '100%', lg: '66%', xl: '50%'}}}>
                    <TextField source="title" variant='h6'/>
                    <TextInput source="title" />
                    <TextInput source="description" />
                    <TextInput source="longDescription" />
                    <SelectInput source="mediaType" choices={MediaTypes}/>
                    <NumberInput source="sequenceNumber" />
                    <SelectInput source="agerating" choices={AgeRatingChoices}/>
                    <ReferenceInput source="primaryGroupID" reference="media" label={getParentType(formProps.record?.mediaType)}>
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
                </Box>
            </form>
        }/>
    </Create>
)};