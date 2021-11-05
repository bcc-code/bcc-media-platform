import { Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput, ReferenceInput, SelectArrayInput, ReferenceField, FormDataConsumer, SimpleFormView, TabbedForm, Tab, FormTab, FormWithRedirect, DateTimeInput, ReferenceManyField, ArrayField, useWarnWhenUnsavedChanges, Toolbar, Link, TopToolbar, CreateButton, ExportButton, Button } from 'react-admin';
// in src/App.js
import React, { cloneElement } from 'react';
import { AgeRatingChoices } from '../types/AgeRating';
import ContentAdd from '@mui/icons-material/Add';
import { useLocation } from 'react-router-dom';
import { Media } from '../types/Media';
import { Box } from '@mui/material';

const ListActions = () => (
    <TopToolbar>
        <CreateButton/>
        <ExportButton/>
    </TopToolbar>
);  

const Total = (props: any) => <div>{props.total}</div>;

export const SeasonList: React.FC<ListProps> = props => {
    return (
        <List actions={<ListActions/>} {...props}  >
            <Datagrid rowClick="edit">
                <TextField source="title" />
                <TextField source="description" />
                <DateField source="createdAt" />
                <DateField source="updatedAt" />
                <ReferenceManyField 
                label="Episodes" 
                reference="episode" 
                target="primaryGroupID" 
                >
                    <Total/>
                </ReferenceManyField>
            </Datagrid>
        </List>
    );
};

export const SeasonEdit: React.FC<EditProps> = props => {
    return (
        <Edit {...props}>
            <FormWithRedirect warnWhenUnsavedChanges render={formProps =>
                <form>
                   <Box sx={{p:4,display:'flex',flexDirection:'column',width:{xs: '100%', lg: '66%', xl: '50%'}}}>
                        <div className='text-sm'>#{formProps.record?.id} <span className="capitalize">Season</span></div>
                        <TextField source="title" variant='h6'/>
                        <Box sx={{ backgroundColor: 'background.paper', color: 'text.secondary', padding: '10px', borderRadius: '10px' }}>
                            <span>Created</span> <DateField source="createdAt" showTime />
                            &nbsp;| <span>Last updated </span> <DateField source="updatedAt" showTime />
                        </Box>
                        <ReferenceInput source="primaryGroupID" reference="show" label="Belongs to">
                            <SelectInput optionText="title" />
                        </ReferenceInput>
                        <NumberInput source="sequenceNumber" />
                        <TextInput source="title" />
                        <TextInput source="description" />
                        <SelectInput source="agerating" choices={AgeRatingChoices}/>
                        <DateTimeInput source="availableFrom"/>
                        <DateTimeInput source="availableTo"/>
                        
                        <SaveButton
                        saving={formProps.saving}
                        disabled={formProps.pristine}
                        handleSubmitWithRedirect={formProps.handleSubmitWithRedirect}/>

                        <div className="mt-4">
                            <h4>Episodes</h4>
                            <Link to={{
                                pathname: "/episode/create",
                                state: { initialValues: { primaryGroupID: formProps.record?.id } }
                            }}>
                                <button type="button">
                                    <ContentAdd />Create episode
                                </button>
                            </Link>
                            <ReferenceManyField label="Episodes" reference="episode" target="primaryGroupID">
                                <ArrayField>
                                    <Datagrid rowClick="edit">
                                        <TextField source="id" />
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

export const SeasonCreate: React.FC<CreateProps> = props => {
    const location = useLocation<{initialValues: Media}>();
    return (
    <Create {...props}>
        <FormWithRedirect warnWhenUnsavedChanges initialValues={location.state?.initialValues} render={formProps =>
            <form>
               <Box sx={{p:4,display:'flex',flexDirection:'column',width:{xs: '100%', lg: '66%', xl: '50%'}}}>
                    <ReferenceInput source="primaryGroupID" reference="show" label="Show">
                        <SelectInput optionText="title" />
                    </ReferenceInput>
                    <NumberInput source="sequenceNumber" />
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