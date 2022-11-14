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

export type FieldType = "text" | "number" | "date" | "datetime-local"  | "var" | "array";

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
	},
	{
		title: "Array",
		value: "array"
	}
]

export type Field = ({column: string, title: string} & ({
	type: "array",
	of: string
} | {
	type: "string",
	options?: {
		title: string,
		value: string
	}[]
} | {
	type: "number" | "datetime-local"
}))

export type Root = {
	id: string;
	filter: Group | null;
	sortBy: string | null;
	sortByDirection: "asc" | "desc" | null;
	limit: number | null;
}

export type DataSetRow = {
	collection: "episodes" | "seasons" | "shows"
	id: number
	season_id?: number
	show_id?: number
	type: "episode" | "standalone" | "series" | "event"
	publishDate?: string
	available_from: string
	available_to: string
	roles: string[]
	tags: string[]
}

export const fields: Field[] = [
	{
		column: "collection",
		title: "Collection",
		type: "string",
		options: [
			{
				title: "Episodes",
				value: "episodes",
			},
			{
				title: "Seasons",
				value: "seasons"
			},
			{
				title: "Shows",
				value: "shows"
			}
		],
	},
	{
		column: "id",
		title: "ID",
		type: "number"
	},
	{
		column: "season_id",
		title: "Season ID",
		type: "number"
	},
	{
		column: "show_id",
		title: "Show ID",
		type: "number"
	},
	{
		column: "agerating_code",
		title: "Age Rating",
		type: "string"
	},
	{
		column: "type",
		title: "Type",
		type: "string"
	},
	{
		column: "publish_date",
		title: "Publish Date",
		type: "datetime-local",
	},
	{
		column: "available_from",
		title: "Available From",
		type: "datetime-local"
	},
	{
		column: "available_to",
		title: "Available To",
		type: "datetime-local"
	},
	{
		column: "roles",
		title: "Roles",
		type: "array",
		of: "string",
	},
	{
		column: "tags",
		title: "Tags",
		type: "array",
		of: "string"
	}
]
