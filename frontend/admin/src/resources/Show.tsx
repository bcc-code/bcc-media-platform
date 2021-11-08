import { Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput, ReferenceInput, SelectArrayInput, ReferenceField, FormDataConsumer, SimpleFormView, TabbedForm, Tab, FormTab, FormWithRedirect, DateTimeInput, ReferenceManyField, ArrayField, useWarnWhenUnsavedChanges, Toolbar, Link, TopToolbar, CreateButton, ExportButton } from 'react-admin';
// in src/App.js
import React, { cloneElement } from 'react';
import { AgeRatingChoices } from '../types/AgeRating';
import ContentAdd from '@mui/icons-material/Add';
import { useLocation } from 'react-router-dom';
import { Media } from '../types/Media';
import { Box, Button, Typography } from '@mui/material';

const ListActions = () => (
    <TopToolbar>
        <CreateButton/>
        <ExportButton/>
    </TopToolbar>
);  

const Total = (props: any) => <div>{props.total}</div>;

export const ShowList: React.FC<ListProps> = props => {
    return (
        <>
            <Typography sx={{mt:3}} variant="h5">Shows</Typography>
            <List actions={<ListActions/>} {...props} filters={[
                <TextInput sx={{mb:2}} size='small' label="Search" source="q" alwaysOn />
            ]}>
                <Datagrid rowClick="edit">
                    <TextField source="title" />
                    <TextField source="description" />
                    <DateField source="publishedTime" />
                    <DateField source="createdAt" />
                    <DateField source="updatedAt" />
                    <ReferenceManyField 
                    label="Seasons" 
                    reference="season" 
                    target="primaryGroupID" 
                    >
                        <Total/>
                    </ReferenceManyField>
                </Datagrid>
            </List>
        </>
    );
};

export const ShowEdit: React.FC<EditProps> = props => {
    return (
        <Edit {...props}>
            <FormWithRedirect warnWhenUnsavedChanges render={formProps =>
                <form>
                   <Box sx={{p:4,display:'flex',flexDirection:'column',width:{xs: '100%', lg: '66%', xl: '50%'}}}>
                        <div className='text-sm'>#{formProps.record?.id} <span className="capitalize">Show</span></div>
                        <TextField source="title" variant='h6'/>
                        <Box sx={{ backgroundColor: 'background.paper', color: 'text.secondary', padding: '10px', borderRadius: '10px' }}>
                            <span>Created</span> <DateField source="createdAt" showTime />
                            &nbsp;| <span>Last updated </span> <DateField source="updatedAt" showTime />
                        </Box>
                        <TextInput source="title" />
                        <TextInput source="description" />
                        <SelectInput source="agerating" choices={AgeRatingChoices}/>
                        <DateTimeInput source="publishedTime"/>
                        <DateTimeInput source="availableFrom"/>
                        <DateTimeInput source="availableTo"/>
                        
                        <SaveButton
                        saving={formProps.saving}
                        disabled={formProps.pristine}
                        handleSubmitWithRedirect={formProps.handleSubmitWithRedirect}/>

                        <Box sx={{mt:4}}>
                            <Typography variant="h6">Seasons</Typography>
                            <Link to={{
                                pathname: "/season/create",
                                state: { initialValues: { primaryGroupID: formProps.record?.id } }
                            }}>
                                <Button 
                                size="small"
                                startIcon={<ContentAdd/>}>
                                    Create season
                                </Button>
                            </Link>
                            <ReferenceManyField label="Child media" reference="media" target="primaryGroupID">
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

export const ShowCreate: React.FC<CreateProps> = props => {
    const location = useLocation<{initialValues: Media}>();
    return (
    <Create {...props}>
        <FormWithRedirect warnWhenUnsavedChanges initialValues={location.state?.initialValues} render={formProps =>
            <form>
               <Box sx={{p:4,display:'flex',flexDirection:'column',width:{xs: '100%', lg: '66%', xl: '50%'}}}>
                    <TextField source="title" variant='h6'/>
                    <TextInput source="title" />
                    <TextInput source="description" />
                    <SelectInput source="agerating" choices={AgeRatingChoices}/>
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