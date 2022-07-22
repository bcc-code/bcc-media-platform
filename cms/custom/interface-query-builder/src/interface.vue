<template>
	<Filter 
		v-if="!loading && value?.filter" 
		:value="value?.filter" 
		:fields="fields" 
		@update:value="handleChange"
		@delete="handleChange(null)" 
	/>
	<div v-else-if="!loading">
		<VButton @click="clearGroup()">Create filter</VButton>
	</div>
	<div v-else>
		<VButton disabled>LOADING</VButton>
	</div>
</template>

<script lang="ts" setup>
import { v4 as uuid } from "uuid";
import { FilterValue, Field as TField } from "./query-builder/types";
import Filter from "./query-builder/Filter.vue";
import { useApi } from "@directus/extensions-sdk";
import { Field } from "@directus/shared/types";
import { defineComponent, PropType } from "vue";
import VButton from "./query-builder/VButton.vue";

type Root = {
	id: string;
	filter: FilterValue;
}

const emit = defineEmits<{ (e: "input", value: Root | null) }>()

function handleChange(filter: FilterValue | null): void {
	if (filter) {
		// Adding an ID on every change to ensure directus picks up on edits
		const root: Root = {
			id: uuid(),
			filter: filter,
		}
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
	props: {
		fieldCollection: {
			type: String,
			required: true,
		},
		value: {
			type: Object as PropType<Root>,
			required: true,
		}
	},
	data() {
		return {
			fields: [] as TField[],
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
			if (field.collection === this.fieldCollection && !field.meta?.hidden) {
				if (!Object.keys(types).includes(field.type)) {
					continue;
				}

				this.fields.push({
					name: field.field,
					type: types[field.type] ?? "text"
				} as TField)
			}
		}

		this.loading = false;
	}
})
</script>
