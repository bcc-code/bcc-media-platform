<template>
	<div style="height: 100%">
		<Datepicker 
			v-model="date" 
			style="height: 100%"
			:text-input="true"
			format="dd/MM/yyyy HH:mm"
			:text-input-options="{
				enterSubmit: true,
				openMenu: true,
				format: ['dd/MM/yy HH:mm', 'dd/MM/yyyy HH:mm', 'dd/MM HH:mm', 'dd HH:mm'],
			}"
	  />
	</div>
</template>

<script lang="ts" setup>
import Datepicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css'
import { computed } from 'vue';

const props = withDefaults(defineProps<{
	value: string | null
}>(), {value: null})

const date = computed({
	get() {
		console.log(props.value)
		return props.value ? new Date(props.value).toUTCString() : null
	},
	set(v) {
		emit("input", v ? new Date(new Date(v).toUTCString()).toISOString() : null)
	}
})

const emit = defineEmits<{
	(e: "input", value: string | null)
}>()
</script>
<style>
.dp__input {
    font-size: 1.25rem;
    line-height: 3rem;
}
</style>
