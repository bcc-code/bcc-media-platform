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
import { useApi } from "@directus/extensions-sdk";
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

let apiFields = null as null | Field[];

const fieldFactory = async (collection?: string) => {
	if (apiFields === null) {
		apiFields = ((await api.get("/fields")).data.data as Field[])
	}
	const fields: TField[] = [];
	collection ??= props.fieldCollection;
	for (const field of apiFields) {
		if (field.collection === collection) {
			if (!Object.keys(types).includes(field.type)) {
				continue;
			}

			fields.push({
				name: field.field,
				type: types[field.type] ?? "text"
			} as TField)
		}
	}

	if (collection === "episodes") {
		fields.push({
			name: "tags.id",
			type: "text"
		})
		fields.push({
			name: "tags.name",
			type: "text"
		})
		const seasonFields = (await fieldFactory("seasons")).filter(i => !i.name.includes(".")).map(i => {
			i.name = "season." + i.name;
			return i
		})
		fields.push(...seasonFields)
	}
	if (["episodes", "seasons"].includes(collection)) {
		const showFields = (await fieldFactory("shows")).filter(i => !i.name.includes(".")).map(i => {
			i.name = "show." + i.name
			return i
		});
		fields.push(...showFields)
	}
	return fields.sort((a,b) => (a.name > b.name ? 1 : -1));
}
</script>
