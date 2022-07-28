<template>
	<QueryBuilder 
		:value="value"
		:field-factory="fieldFactory"
		@update:value="r => $emit('input', r)"
	></QueryBuilder>
</template>

<script lang="ts" setup>
import QueryBuilder from "./query-builder/QueryBuilder.vue";
import { Root } from "./query-builder";
import { Field } from "@directus/shared/types";
import { useApi } from "@directus/extensions-sdk";
import { Field as TField} from "./query-builder";

const props = defineProps<{
	value: Root,
	fieldCollection: string,
}>();
defineEmits<{
	(e: 'input', root: Root | null)
}>()

const types = {
    string: "text",
    text: "text",
    integer: "number",
    date: "date",
    dateTime: "datetime-local",
};

const fieldFactory = async () => {
	const fields: TField[] = [];
	((await useApi().get("/fields")).data.data as Field[]).forEach(field => {
		if (field.collection === props.fieldCollection && !field.meta?.hidden) {
			if (!Object.keys(types).includes(field.type)) {
				return;
			}

			fields.push({
				name: field.field,
				type: types[field.type] ?? "text"
			} as TField)
		}
	})
	return fields.sort((a,b) => (a.name > b.name ? 1 : -1));
}
</script>
