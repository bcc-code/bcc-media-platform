<template>
    <div class="filter">
        <input type="text" v-model="property" @change="handleUpdate()" placeholder="Property" />
        <select v-model="operator" @change="handleUpdate()">
            <option v-for="op in operators">{{op}}</option>
        </select>
        <input type="text" v-model="value" @change="handleUpdate()" placeholder="Value" />
    </div>
</template>
<script lang="ts" setup>
import { ref } from 'vue';
import { Filter, Operator } from './types';

const props = defineProps<{
    filter: Filter
}>()

const property = ref(props.filter.property);
const operator = ref(props.filter.operator);
const value = ref(props.filter.value);

const operators: Operator[] = [
    "eq",
    "neq"
]

const emit = defineEmits<{(e: "update:filter", filter: Filter)}>();

function handleUpdate() {
    emit("update:filter", {
        type: "filter",
        property: property.value,
        operator: operator.value,
        value: value.value,
    })
}
</script>
