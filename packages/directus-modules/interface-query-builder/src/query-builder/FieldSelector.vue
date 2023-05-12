<template>
    <v-select
        v-model="selectedValue"
        :items="fields"
        item-text="title"
        item-value="column"
    ></v-select>
</template>
<script lang="ts" setup>
import { computed } from 'vue';
import { Field } from '.';

const props = defineProps<{
    fields: Field[];
    value: string | null;
}>();

const selectedValue = computed({
    get() {
        return props.value
    },
    set(v) {
        emit("update:value", v)
    }
})

const emit = defineEmits<{
    (e: "update:value", v: string | null)
}>()
</script>
