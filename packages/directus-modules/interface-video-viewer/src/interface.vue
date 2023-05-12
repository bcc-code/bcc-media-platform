<template>
	<div>
		<div>
			<Viewer :factory="factory"></Viewer>
		</div>
	</div>
</template>

<script lang="ts" setup>
import { useApi } from "@directus/extensions-sdk"
import Viewer from './viewer/Viewer.vue';

const props = defineProps<{
	primaryKey: string;
}>()

const api = useApi();

const factory = async () => {
	const result = await api.get("/preview/asset/" + props.primaryKey)

	return result.data;
}
</script>
