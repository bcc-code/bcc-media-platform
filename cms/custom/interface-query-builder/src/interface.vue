<template>
	<Filter v-if="!loading && value" :value="value" :fields="episodeFields" @update:value="handleChange" @delete="handleChange(null)" />
	<div v-else>
		<button @click="clearGroup()">Create filter</button>
	</div>
	<div v-if="loading">LOADING</div>
</template>

<script lang="ts" setup>
import { v4 as uuid } from "uuid";
import { FilterValue, Field as TField } from "./query-builder/types";
import Filter from "./query-builder/Filter.vue";
import {useApi} from "@directus/extensions-sdk";
import { Field } from "@directus/shared/types";
import { defineComponent } from "vue";

type Root = FilterValue & {
	id: string;
}

defineProps<{
	value: FilterValue;
}>();

const emit = defineEmits<{(e: "input", value: FilterValue | null)}>()

function handleChange(value: FilterValue | null): void {
	if (value) {
		// Adding an ID on every change to ensure directus picks up on edits
		const root: Root = Object.assign({}, value, {
			id: uuid(),
		})
		emit('input', root);
	} else {
		emit('input', null);
	}
}

function clearGroup() {
	handleChange({
		"and": [],
	})
}
</script>
<script lang="ts">

export default defineComponent({
	name: "interface",
	data() {
		return {
			episodeFields: [] as TField[],
			loading: true,
		}
	},
	async mounted() {
		const r = await useApi().get("/fields")

		const fields = r.data.data as Field[];

		const types = {
			string: "text",
			text: "text",
			integer: "number",
			date: "date",
			dateTime: "datetime-local",
		}

		for (const field of fields) { 
			if (field.collection === "episodes" && !field.meta?.hidden) {
				if (!Object.keys(types).includes(field.type)) {
					console.log(field.type);
					continue;
				}

				this.episodeFields.push({
					name: field.field,
					type: types[field.type] ?? "text"
				} as TField)
			}
		}
	
		this.loading = false;
	}
})
</script>
