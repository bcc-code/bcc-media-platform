<template>
    <select 
        v-model="selectedValue" 
        @change="$emit('update:value', selectedValue)"
        placeholder="Property..."
    >
        <option 
            v-for="prop in fields" 
            :key="prop.name" 
            :value="prop.name"
        >{{ snakeToPascal(prop.name) }}</option>
    </select>
</template>
<script lang="ts" setup>
import { ref } from 'vue';
import { Field, snakeToPascal } from '.';

const props = defineProps<{
    fields: Field[];
    value: string | null;
}>();

const selectedValue = ref(props.value)

defineEmits<{
    (e: "update:value", v: string | null)
}>()
</script>