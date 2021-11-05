import { Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput, ReferenceInput, SelectArrayInput, ReferenceField, FormDataConsumer, SimpleFormView, TabbedForm, Tab, FormTab, FormWithRedirect, DateTimeInput, ReferenceManyField, ArrayField, useWarnWhenUnsavedChanges, Toolbar, Link, TopToolbar, CreateButton, ExportButton, Button } from 'react-admin';
// in src/App.js
import React, { cloneElement } from 'react';
import { AgeRatingChoices } from '../types/AgeRating';
import ContentAdd from '@mui/icons-material/Add';
import { useLocation } from 'react-router-dom';
import { Media } from '../types/Media';
import { Typography } from '@mui/material';

const ListActions = () => (
    <TopToolbar>
        <CreateButton/>
        <ExportButton/>
    </TopToolbar>
);  

const Total = (props: any) => <div>{props.total}</div>;
const episodeFilters = [
    <TextInput label="Search" source="q" alwaysOn />,
];
export const EpisodeList: React.FC<ListProps> = props => {
    return (
        <div>
            <Typography variant="h5">Episodes</Typography>
            <List actions={<ListActions/>} {...props} filters={episodeFilters} title="Episodes" >
                <Datagrid rowClick="edit">
                    <TextField source="title" />
                    <TextField source="description" />
                    <DateField source="createdAt" />
                    <DateField source="updatedAt" />
                </Datagrid>
            </List>
        </div>
    );
};

export const EpisodeEdit: React.FC<EditProps> = props => {
    return (
        <Edit {...props}>
            <FormWithRedirect warnWhenUnsavedChanges render={formProps =>
                <form>
                    <div className="p-4 flex flex-col">
                        <div className='text-sm'>#{formProps.record?.id} <span className="capitalize">Episode</span></div>
                        <TextField source="title" variant='h6'/>
                        <div>
                        <div className="bg-gray-100 p-2 rounded mt-2 mb-6 text-sm">
                            <span>Created</span> <DateField source="createdAt" showTime />
                            &nbsp;| <span>Last updated </span> <DateField source="updatedAt" showTime />
                        </div></div>
                        <ReferenceInput required source="primaryGroupID" reference="season" label="Belongs to season">
                            <SelectInput optionText="title" />
                        </ReferenceInput>
                        <NumberInput source="sequenceNumber" />
                        <TextInput source="title" />
                        <TextInput source="description" />
                        <TextInput source="longDescription" />
                        <DateTimeInput source="availableFrom"/>
                        <DateTimeInput source="availableTo"/>
                        <SelectInput source="agerating" choices={AgeRatingChoices}/>
                        <ReferenceInput source="assetID" reference="assets" label="Asset">
                            <SelectInput optionText="name" />
                        </ReferenceInput>
                        
                        <SaveButton
                        saving={formProps.saving}
                        disabled={formProps.pristine}
                        handleSubmitWithRedirect={formProps.handleSubmitWithRedirect}/>

                        <div className="mt-4">
                            <h4>Subclips</h4>
                            <Link to={{
                                pathname: "/subclip/create",
                                state: { initialValues: { primaryGroupID: formProps.record?.id } }
                            }}>
                                <button type="button">
                                    <ContentAdd />Create subclip
                                </button>
                            </Link>
                            <ReferenceManyField label="Episodes" reference="subclip" target="subclippedMediaID">
                                <ArrayField>
                                    <Datagrid rowClick="edit">
                                        <TextField source="id" />
                                        <TextField source="title" />
                                        <TextField source="description" />
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

export const EpisodeCreate: React.FC<CreateProps> = props => {
    const location = useLocation<{initialValues: Media}>();
    return (
    <Create {...props}>
        <FormWithRedirect warnWhenUnsavedChanges initialValues={location.state?.initialValues} render={formProps =>
            <form>
                <div className="p-4 flex flex-col">
                    <ReferenceInput required source="primaryGroupID" reference="season" label="Belongs to season">
                        <SelectInput optionText="title" />
                    </ReferenceInput>
                    <NumberInput source="sequenceNumber" />
                    <TextInput source="title" />
                    <TextInput source="description" />
                    <TextInput source="longDescription" />
                    <SelectInput source="agerating" choices={AgeRatingChoices}/>
                    <ReferenceInput source="assetID" reference="assets" label="Asset">
                        <SelectInput optionText="name" />
                    </ReferenceInput>
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