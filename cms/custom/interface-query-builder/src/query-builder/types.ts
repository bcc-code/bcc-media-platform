export type Type = "group" | "filter"

export type Operator = "eq" | "neq"

export type Child = Group | Filter

export type Group = {
    type: "group";
    name: string;
    operator: "and" | "or";
    children: Child[];
}

export type Filter = {
    type: "filter";
    property: string;
    operator: Operator;
    value: string;
}
