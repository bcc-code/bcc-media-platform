<template>
	<Group v-if="value" :group="value" @update:group="handleChange" />
	<div v-else>
		<button @click="clearGroup()">Set group</button>
	</div>
</template>

<script lang="ts" setup>
import Group from "./query-builder/group.vue";
import { Group as TGroup } from './query-builder/types';
import { v4 as uuid } from "uuid";

type Root = TGroup & {
	id: string;
}

const props = defineProps<{
	value: Root;
}>();

const emit = defineEmits<{(e: "input", group: Root)}>()

function handleChange(value: TGroup): void {
	// Adding an ID on every change to ensure directus picks up on edits
	const root: Root = Object.assign({
		id: uuid(),
	}, value)
	emit('input', root);
}

function clearGroup() {
	handleChange({
		type: "group",
		name: "",
		children: [],
		operator: "and",
	})
}
</script>
