import { Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput, ReferenceInput, SelectArrayInput, ReferenceField, FormDataConsumer, SimpleFormView, TabbedForm, Tab, FormTab, FormWithRedirect, DateTimeInput, ReferenceManyField, ArrayField, useWarnWhenUnsavedChanges, Toolbar, Link, TopToolbar, CreateButton, ExportButton, AutocompleteInput, ReferenceArrayInput } from 'react-admin';
// in src/App.js
import React, { cloneElement } from 'react';
import { AgeRatingChoices } from '../types/AgeRating';
import ContentAdd from '@mui/icons-material/Add';
import { useLocation } from 'react-router-dom';
import { Media } from '../types/Media';
import { Box, Typography, Button } from '@mui/material';

const ListActions = () => (
    <TopToolbar>
        <CreateButton/>
        <ExportButton/>
    </TopToolbar>
);  

const Total = (props: any) => <div>{props.total}</div>;
export const EpisodeList: React.FC<ListProps> = props => {
    return (
        <div>
            <Typography sx={{mt:3}} variant="h5">Episodes</Typography>
            <List actions={<ListActions/>} {...props} filters={[
                <TextInput sx={{mb:2}} size='small' label="Search" source="q" alwaysOn />
            ]}>
                <Datagrid rowClick="edit">
                    <TextField source="title" />
                    <TextField source="description" />
                    <DateField source="publishedTime" />
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
                    <Box sx={{p:4,display:'flex',flexDirection:'column',width:{xs: '100%', lg: '66%', xl: '50%'}}}>
                        <div className='text-sm'>#{formProps.record?.id} <span className="capitalize">Episode</span></div>
                        <TextField source="title" variant='h6'/>
                            <Box sx={{ backgroundColor: 'background.paper', color: 'text.secondary', padding: '10px', borderRadius: '10px' }}>
                                <span>Created</span> <DateField source="createdAt" showTime />
                                &nbsp;| <span>Last updated </span> <DateField source="updatedAt" showTime />
                            </Box>
                        <ReferenceInput required source="primaryGroupID" reference="season" label="Belongs to season">
                            <SelectInput optionText="title" />
                        </ReferenceInput>
                        <NumberInput source="sequenceNumber" />
                        <TextInput source="title" />
                        <TextInput source="description" />
                        <TextInput source="longDescription" />
                        <DateTimeInput source="publishedTime"/>
                        <DateTimeInput source="availableFrom"/>
                        <DateTimeInput source="availableTo"/>
                        <SelectInput source="agerating" choices={AgeRatingChoices}/>
                        <ReferenceInput source="assetID" reference="assets" label="Asset" className="w-full" >
                            <AutocompleteInput optionText="name" />
                        </ReferenceInput>
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

                        <Box sx={{mt:4}}>
                            <Typography variant="h6">Subclips</Typography>
                            <Link to={{
                                pathname: "/subclip/create",
                                state: { initialValues: { primaryGroupID: formProps.record?.id } }
                            }}>
                                <Button 
                                size="small"
                                startIcon={<ContentAdd/>}>
                                    Create subclip
                                </Button>
                            </Link>
                            <ReferenceManyField reference="subclip" target="subclippedMediaID">
                                <ArrayField>
                                    <Datagrid rowClick="edit">
                                        <TextField source="id" />
                                        <TextField source="title" />
                                        <TextField source="description" />
                                    </Datagrid>
                                </ArrayField>
                            </ReferenceManyField>
                        </Box>
                    </Box>
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
               <Box sx={{p:4,display:'flex',flexDirection:'column',width:{xs: '100%', lg: '66%', xl: '50%'}}}>
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
                    <ReferenceArrayInput source="usergroups" reference="usergroups">
                        <SelectArrayInput optionText="id" />
                    </ReferenceArrayInput>
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