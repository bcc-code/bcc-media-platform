<template>
	<QueryBuilder 
		:value="value"
		:field-factory="fieldFactory"
		@update:value="r => $emit('input', r)"
	></QueryBuilder>
    <div style="margin-top: 10px; margin-bottom: 10px"></div>
	<Preview
		:factory="previewFactory"
	></Preview>
	<div v-if="error" style="color:red">
		{{error}}
	</div>
</template>

<script lang="ts" setup>
import QueryBuilder from "./query-builder/QueryBuilder.vue";
import { Root } from "./query-builder";
import { Field } from "@directus/shared/types";
import { useApi, useItems } from "@directus/extensions-sdk";
import { Field as TField} from "./query-builder";
import { ref } from "vue";
import { Item } from "./preview/types";
import Preview from "./preview/Preview.vue";

const props = defineProps<{
	value: Root,
	fieldCollection: string,
	primaryKey: string
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

const api = useApi();

const error = ref(null as string | null)

const previewFactory = async () => {
	const views = [] as Item[];
	error.value = null;
	try {
		const r = await api.post("/preview/collection", {
			filter: props.value,
			collection: props.fieldCollection,
		})
		let total = 0;
		for (const item of r.data) {
			if (total >= 20) {
				continue;
			}
			total++;
			views.push({
				id: item.id,
				title: item.title,
				type: props.fieldCollection
			})
		}
	} catch {
		error.value = "Failed to fetch from api"
	}
	return views;
}

const fieldFactory = async () => {
	const fields: TField[] = [];
	((await api.get("/fields")).data.data as Field[]).forEach(field => {
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
