import React from 'react';
import { ReferenceInputProps, Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput, ReferenceInput, SelectArrayInput, ReferenceField, FormDataConsumer, SimpleFormView, TabbedForm, Tab, FormTab, FormWithRedirect, DateTimeInput, ReferenceManyField, ArrayField, useWarnWhenUnsavedChanges, Toolbar, Link, SelectInputProps, Button, AutocompleteInput } from 'react-admin';
import { useFormState } from 'react-final-form';


export const AssetList: React.FC<ListProps> = props => (
    <List {...props} filters={[
        <TextInput sx={{mb:2}} size='small' label="Search" source="q" alwaysOn />
    ]}>
        <Datagrid>
            <TextField source="id" />
            <TextField source="sourceID" />
            <TextField source="name" />
            <ReferenceField source="publishedVersionID" reference="asset-versions" label="Published version">
                <NumberField source="id"/>
            </ReferenceField>
        </Datagrid>
    </List>
);

export const AssetEdit: React.FC<EditProps> = props => (
    <Edit {...props}>
        <FormWithRedirect warnWhenUnsavedChanges render={formProps => (
            <SimpleForm {...formProps}>
                <NumberInput source="id" />
                <TextInput source="name" />
                <TextInput source="sourceID" />
                <ReferenceInput source="publishedVersionID" reference="asset-versions" filterToQuery={searchText => ({ assetId: formProps.record!.id })} label="Published version">
                    <SelectInput optionText="id" />
                </ReferenceInput>
            </SimpleForm>
        )}/>
    </Edit>
);