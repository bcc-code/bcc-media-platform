// This file is not meant to be run directly but is rather a scaffold for programatically manipulating
// the Directus Yaml schema

console.error("Be sure you know what you are doing")
process.exit(1)

import {load, dump} from "js-yaml"
import {readFileSync, writeFileSync} from "fs"

interface schema {
    version:     number;
    directus:    string;
    collections: Collection[];
    fields:      Field[];
    relations:   any[];
}

enum Status {
    Archived = "archived",
    Draft = "draft",
    Published = "published",
}

interface Collection {
    collection: string;
    meta:       CollectionMeta;
    schema:     CollectionSchema | null;
}

interface CollectionMeta {
    accountability:          string;
    archive_app_filter:      boolean;
    archive_field:           null | string;
    archive_value:           Status | null;
    collapse:                string;
    collection:              string;
    color:                   null;
    display_template:        null | string;
    group:                   null | string;
    hidden:                  boolean;
    icon:                    string;
    item_duplication_fields: string[] | null;
    note:                    null | string;
    singleton:               boolean;
    sort:                    number;
    sort_field:              null | string;
    translations:            null;
    unarchive_value:         Status| null;
}


interface CollectionSchema {
    comment: null;
    name:    string;
    schema:  string;
}

interface Field {
    collection: string;
    field:      string;
    meta:       FieldMeta;
    schema:     FieldSchema | null;
    type:       Type;
}

enum Display {
    Datetime = "datetime",
    FormattedValue = "formatted-value",
    Labels = "labels",
    Raw = "raw",
    RelatedValues = "related-values",
    Translations = "translations",
    User = "user",
}

interface DisplayOptions {
    relative?:        boolean;
    choices?:         DisplayOptionsChoice[];
    showAsDot?:       boolean;
    template?:        string;
    defaultLanguage?: string;
    languageField?:   string;
    userLanguage?:    boolean;
    format?:          boolean;
}

interface DisplayOptionsChoice {
    text:       string;
    value:      Status;
    foreground: string;
    background: string;
}

interface FieldMeta {
    collection:         string;
    conditions:         Condition[] | null;
    display:            Display | null;
    display_options:    DisplayOptions | null;
    field:              string;
    group:              null | string;
    hidden:             boolean;
    interface:          null | string;
    note:               null | string;
    options:            Options | null;
    readonly:           boolean;
    required:           boolean;
    sort:               number | null;
    special:            string[] | null;
    translations:       Translation[] | null;
    validation:         any;
    validation_message: null;
    width:              Width;
}

enum Width {
    Full = "full",
    Half = "half",
}

enum ForeignKeyColumn {
    Code = "code",
    ID = "id",
}


interface Options {
    template?:      string;
    iconLeft?:      string;
    choices?:       OptionsChoice[];
    enableCreate?:  boolean;
    placeholder?:   null | string;
    icon?:          string;
    language?:      string;
    label?:         string;
    languageField?: ForeignKeyColumn;
    headerIcon?:    string;
    crop?:          boolean;
    folder?:        null | string;
    start?:         string;
    color?:         string;
    text?:          string;
    clear?:         boolean;
    font?:          string;
    softLength?:    number;
    trim?:          boolean;
}

interface OptionsChoice {
    text:  string;
    value: string;
}

interface Translation {
    language:    null | string;
    translation: string;
}
interface Condition {
    name:      string;
    hidden?:   boolean;
    rule:      any;
    readonly?: boolean;
}

export enum DataType {
    Bigint = "bigint",
    Boolean = "boolean",
    CharacterVarying = "character varying",
    Integer = "integer",
    JSON = "json",
    Text = "text",
    TimestampWithTimeZone = "timestamp with time zone",
    TimestampWithoutTimeZone = "timestamp without time zone",
    UUID = "uuid",
}

interface FieldSchema {
    comment:               null;
    data_type:             DataType;
    default_value:         boolean | null | string;
    foreign_key_column:    ForeignKeyColumn | null;
    foreign_key_schema:    string | null;
    foreign_key_table:     null | string;
    generation_expression: null;
    has_auto_increment:    boolean;
    is_generated:          boolean;
    is_nullable:           boolean;
    is_primary_key:        boolean;
    is_unique:             boolean;
    max_length:            number | null;
    name:                  string;
    numeric_precision:     number | null;
    numeric_scale:         number | null;
    schema:                string;
    table:                 string;
}

export enum Type {
    Alias = "alias",
    BigInteger = "bigInteger",
    Boolean = "boolean",
    DateTime = "dateTime",
    Integer = "integer",
    JSON = "json",
    String = "string",
    Text = "text",
    Timestamp = "timestamp",
    UUID = "uuid",
}


// Get document, or throw exception on error
try {
	const doc = load(readFileSync('../schema.yml', 'utf8')) as schema;
	doc.fields = doc.fields.map(x => {
		if (x.field != "date_created" && x.field != "date_updated") {
			return x;
		}
		console.log(x.field)
		x.schema.is_nullable = false;
		x.schema.default_value = "CURRENT_TIMESTAMP"
		x.meta.special = Array.from(new Set([...x.meta.special, "date-created", "date-updated"]));
		return x;
	})

	let yaml = dump(doc)
	writeFileSync("../schema.yml", yaml)

} catch (e) {
	console.log(e);
}
