import React from "react";
import { Datagrid, Edit, ListProps, EditProps, List, SimpleForm, TextField, TextInput } from "react-admin";

export const TagList: React.FC<ListProps> = props => (
    <List {...props}>
        <Datagrid rowClick="edit">
            <TextField source="title" />
            <TextField source="type" />
        </Datagrid>
    </List>
);

export const TagEdit: React.FC<EditProps> = props => (
    <Edit {...props} undoable={false}>
        <SimpleForm>
            <TextInput source="title" />
            <TextInput source="type" />
        </SimpleForm>
    </Edit>
);