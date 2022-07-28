<template>
    <Suspense>
        <template #default>
            <RootGroup
                :value="value"
                :field-factory="fieldFactory"
                @update:value="v => $emit('update:value', v)"
            />
        </template>
        <template #fallback>
            Loading builder...
        </template>
    </Suspense>
</template>
<script lang="ts" setup>
import { Field, Root } from './types';
import RootGroup from "./RootGroup.vue";

defineProps<{
    value: Root | null;
    fieldFactory: () => Promise<Field[]>
}>()
defineEmits<{
	(e: "update:value", value: Root | null),
}>()
</script>