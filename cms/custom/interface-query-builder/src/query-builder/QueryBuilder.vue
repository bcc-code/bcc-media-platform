<template>
    <Suspense>
        <template #default>
            <RootGroup
                :value="value"
                @update:value="v => $emit('update:value', v)"
            />
        </template>
        <template #fallback>
            Loading builder...
        </template>
    </Suspense>
</template>
<script lang="ts" setup>
import { Root } from './types';
import RootGroup from "./RootGroup.vue";

defineProps<{
    value: Root | null;
}>()
defineEmits<{
	(e: "update:value", value: Root | null),
}>()
</script>
