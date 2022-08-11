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
import { useApi, useItems } from "@directus/extensions-sdk";
import { Field as TField} from "./query-builder";
import { ref } from "vue";

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

const typeToCollection = {
	"page": "pages",
	"show": "shows",
	"season": "seasons",
	"episode": "episodes"
}

const itemPreviews = ref([] as {
	title: string
	id: string
}[])

const previewFactory = async () => {
	const api = useApi();
	api.get("/preview/collection/" + props.primaryKey).then(async (r) => {
		const view: any[] = [];
		let total = 0;
		for (const item of r.data) {
			if (total >= 10) {
				continue;
			}
			total++;
			view.push({
				id: item.id,
				title: item.title.no ?? item.title.en,
				type: item.type,
			})
		}
	})
}
previewFactory();

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
