<template>
	<QueryBuilder
		:value="value"
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
import { useApi } from "@directus/extensions-sdk";
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
	let count = 0;
	error.value = null;
	try {
		const r = await api.post("/tools/preview/collection", {
			filter: props.value,
			collection: props.fieldCollection,
		})
		let total = 0;
		for (const item of r.data) {
			count++
			if (total >= 50) {
				continue;
			}
			total++;
			views.push({
				id: item.id,
				title: item.title,
				collection: item.collection
			})
		}
	} catch {
		error.value = "Failed to fetch from api"
	}
	return {
		count,
		views
	};
}
</script>
