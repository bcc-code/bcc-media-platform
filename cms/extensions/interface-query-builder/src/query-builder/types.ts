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

export type Field = ({column: string, title: string, supportedOperators: string[]} & ({
	type: "array",
	of: string
} | {
	type: "string",
	options?: {
		title: string,
		value: string
	}[],
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
		title: "Table Name",
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
			},
            {
                title: "Playlists",
                value: "playlists",
            },
            {
                title: "Shorts",
                value: "shorts"
            }
		],
		supportedOperators: ["==", "!="]
	},
	{
		column: "id",
		title: "ID",
		type: "number",
		supportedOperators: ["==", "!=", "<", ">", "<=", "=>", "in"]
	},
	{
		column: "number",
		title: "Number",
		type: "number",
		supportedOperators: ["==", "!=", "<", ">", "<=", "=>", "in"]
	},
	{
		column: "season_id",
		title: "Season ID",
		type: "number",
		supportedOperators: ["==", "!=", "<", ">", "<=", "=>", "in"]
	},
	{
		column: "show_id",
		title: "Show ID",
		type: "number",
		supportedOperators: ["==", "!=", "<", ">", "<=", "=>", "in"]
	},
	{
		column: "agerating_code",
		title: "Age Rating",
		type: "string",
		supportedOperators: ["==", "!=", "<", ">", "<=", "=>", "in"]
	},
	{
		column: "type",
		title: "Type",
		type: "string",
		supportedOperators: ["==", "!=", "<", ">", "<=", "=>", "in"]
	},
	{
		column: "publish_date",
		title: "Publish Date",
		type: "datetime-local",
		supportedOperators: ["==", "!=", "<", ">", "<=", "=>"]
	},
	{
		column: "available_from",
		title: "Available From",
		type: "datetime-local",
		supportedOperators: ["==", "!=", "<", ">", "<=", "=>"]
	},
	{
		column: "available_to",
		title: "Available To",
		type: "datetime-local",
		supportedOperators: ["==", "!=", "<", ">", "<=", "=>"]
	},
	{
		column: "roles",
		title: "Roles",
		type: "array",
		of: "string",
		supportedOperators: ["is", "!is"]
	},
	{
		column: "tags",
		title: "Tags",
		type: "array",
		of: "string",
		supportedOperators: ["is", "!is"]
	}
]
