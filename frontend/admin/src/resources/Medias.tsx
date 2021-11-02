import { Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput, ReferenceInput, SelectArrayInput, ReferenceField, FormDataConsumer, SimpleFormView, TabbedForm, Tab, FormTab, FormWithRedirect, DateTimeInput, ReferenceManyField, ArrayField, useWarnWhenUnsavedChanges, Toolbar, createMuiTheme, Link } from 'react-admin';
// in src/App.js
import React from 'react';
import { AgeRatingChoices } from '../models/AgeRating';
import ContentAdd from '@material-ui/icons/Add';
import { useLocation } from 'react-router-dom';
import { Media } from '../models/Media';
import { MediaType } from '../models/MediaType';
const baseTheme = createMuiTheme();


const MediaTypes = [
    {id: 'show', name: 'Show'},
    {id: 'season', name: 'Season'},
    {id: 'episode', name: 'Episode'},
    {id: 'standalone', name: 'Standalone'},
    {id: 'subclip', name: 'Subclip'},
    {id: 'marker', name: 'Marker'},
];

function getParentType(mediaType: MediaType): MediaType | undefined {
    switch (mediaType) {
        case "standalone": return undefined
        case "episode": return MediaType.Season
        case "season": return MediaType.Show
        case "show": return undefined
        default: return undefined
    }
}

function getChildType(mediaType: MediaType): MediaType | undefined {
    switch (mediaType){
        case "standalone": return undefined
        case "episode": return undefined
        case "season": return MediaType.Episode
        case "show": return MediaType.Season
        default: return undefined
    }
}


export const MediaList: React.FC<ListProps> = props => {
    let filter = {};
    const search = props.location?.search;
    if (search) {
        const params = new URLSearchParams(search);
        const mediaType = params.get('mediaType'); // bar
        filter = {
            mediaType: mediaType
        }
    }
    return (
        <List {...props} filter={filter}>
            <Datagrid rowClick="edit">
                <TextField source="mediaType" />
                <TextField source="title" />
                <TextField source="description" />
                <ReferenceField source="primaryGroupID" reference="medias" label="Parent media">
                    <TextField source="title"/>
                </ReferenceField>
                <NumberField source="sequenceNumber" />
                <ReferenceField source="referenceMediaID" reference="medias" label="Reference media">
                    <TextField source="title"/>
                </ReferenceField>
                <ReferenceField source="subclippedMediaID" reference="medias" label="Subclip of">
                    <TextField source="title"/>
                </ReferenceField>
                <NumberField source="startTime" />
                <NumberField source="endTime" />
                <DateField source="createdAt" />
                <DateField source="updatedAt" />
                <EditButton/>
            </Datagrid>
        </List>
    );
};

export const MediaEdit: React.FC<EditProps> = props => {
    return (
        <Edit {...props}>
            <FormWithRedirect warnWhenUnsavedChanges render={formProps =>
                <form>
                    <div className="p-4 flex flex-col">
                        <div className='text-sm'>#{formProps.record?.id} <span className="capitalize">{formProps.record?.mediaType}</span></div>
                        <TextField source="title" variant='h6'/>
                        <div>
                        <div className="bg-gray-100 p-2 rounded my-2 text-sm">
                            <span>Created</span> <DateField source="createdAt" showTime />
                            &nbsp;| <span>Last updated </span> <DateField source="updatedAt" showTime />
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

                        <div className="mt-4">
                            <h4>Child media</h4>
                            <Link to={{
                                pathname: "/medias/create",
                                state: { initialValues: { primaryGroupID: formProps.record?.id, mediaType: getChildType(formProps.record?.mediaType) } }
                            }}>
                                <button type="button">
                                    <ContentAdd />Create {getChildType(formProps.record?.mediaType)}
                                </button>
                            </Link>
                            <ReferenceManyField label="Child media" reference="medias" target="primaryGroupID">
                                <ArrayField>
                                    <Datagrid rowClick="edit">
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
    )
};

export const MediaCreate: React.FC<CreateProps> = props => {
    const location = useLocation<{initialValues: Media}>();
    return (
    <Create {...props}>
        <FormWithRedirect warnWhenUnsavedChanges initialValues={location.state?.initialValues} render={formProps =>
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
)};