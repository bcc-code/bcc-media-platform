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

const toNoLocaleDate = (date: Date) => {
	const d = new Date(date.toUTCString())

	return `${d.getFullYear()}-${(d.getMonth() + 1).toString().padStart(2, "0")}-${d.getDate().toString().padStart(2, "0")}T${d.getHours().toString().padStart(2, "0")}:${d.getMinutes().toString().padStart(2, "0")}:00`
}

const date = computed({
	get() {
		return props.value ? toNoLocaleDate(new Date(props.value)) : null
	},
	set(v) {
		if (v) {
			v = toNoLocaleDate(new Date(v))
		}
		emit("input", v ? v : null)
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
