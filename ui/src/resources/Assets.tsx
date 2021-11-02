import React from 'react';
import { ReferenceInputProps, Datagrid, List, NumberField, TextField, DateField, ListProps, EditButton, SelectInput, Edit, SimpleForm, SaveButton, EditProps, CreateProps, Create, TextInput, NumberInput, ReferenceInput, SelectArrayInput, ReferenceField, FormDataConsumer, SimpleFormView, TabbedForm, Tab, FormTab, FormWithRedirect, DateTimeInput, ReferenceManyField, ArrayField, useWarnWhenUnsavedChanges, Toolbar, createMuiTheme, Link, SelectInputProps, Button } from 'react-admin';
import { useFormState } from 'react-final-form';


export const AssetList: React.FC<ListProps> = props => (
    <List {...props}>
        <Datagrid rowClick="edit">
            <TextField source="id" />
            <TextField source="sourceID" />
            <ReferenceField source="publishedVersionID" reference="asset-versions" label="Published version">
                <NumberField source="id"/>
            </ReferenceField>
            <NumberField source="name" />
        </Datagrid>
    </List>
);

const ReferenceChildInput= (props: ReferenceInputProps) => {
    const { values } = useFormState();
    let x = props.filterBySource.split(",")
    let filter = {
        [x[1]]: values[x[0]]
    };
    return <ReferenceInput filter={filter} {...props}/>
}

export const AssetEdit: React.FC<EditProps> = props => (
    <Edit {...props}>
        <SimpleForm>
            <TextInput source="id" />
            <TextInput source="sourceID" />
            <ReferenceChildInput source="publishedVersionID" reference="asset-versions" filterBySource="id,assetID" perPage={10} label="Published version">
                <SelectInput optionText="id" />
            </ReferenceChildInput>
            <NumberInput source="name" />
        </SimpleForm>
    </Edit>
);