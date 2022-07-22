<template>
	<Suspense>
		<template #default>
			<QueryBuilder 
				:value="value" 
				:field-collection="fieldCollection"
				@input="r => $emit('input', r)"
			></QueryBuilder>
		</template>
		<template #fallback>
			Loading...
		</template>
	</Suspense>
</template>

<script lang="ts" setup>
import QueryBuilder from "./query-builder/QueryBuilder.vue";
import { Root } from "./query-builder";

defineProps<{
	value: Root,
	fieldCollection: string,
}>();
defineEmits<{
	(e: 'input', root: Root | null)
}>()
</script>
