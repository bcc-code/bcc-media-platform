export type Operator = "==" | "!=" | "<" | ">" | "!"

export type FilterValue = string | {
    [operator: string]: FilterValue | FilterValue[];
}

export type FieldType = "text" | "number" | "date" | "datetime";

export type Field = {
    type: FieldType;
    name: string;
}
