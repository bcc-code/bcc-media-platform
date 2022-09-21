export type Operator = "==" | "!=" | "<" | ">" | "!"

export type Variable = {
	var: string
}

export type Filter = {
    [operator: string]: (string | string[] | number | Variable)[];
}

export type Group = {
	[operator: string]: (Filter | Group)[];
}

export type FieldType = "text" | "number" | "date" | "datetime-local"  | "var";

export const fieldTypes: {
	title: string,
	value: FieldType
}[] = [
	{
		title: "Variable",
		value: "var"
	},
	{
		title: "Text",
		value: "text",
	},
	{
		title: "Number",
		value: "number",
	},
	{
		title: "Date",
		value: "date",
	},
	{
		title: "DateTime",
		value: "datetime-local"
	}
]

export type Field = {
    type: FieldType;
    name: string;
}

export type Root = {
	id: string;
	filter: Group | null;
	sortBy: string | null;
	sortByDirection: "asc" | "desc" | null;
	limit: number | null;
}
