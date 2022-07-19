<template>
    <div class="child" v-if="child">
        <Group v-if="child.type === 'group'" :group="child" @update:group="(i) => $emit('update:child', i)"/>
        <Filter v-if="child.type === 'filter'" :filter="child" @update:filter="(i) => $emit('update:child', i)" />
        <button @click="$emit('delete')">DELETE</button>
    </div>
</template>
<script lang="ts" setup>
import Filter from "./filter.vue"
import Group from "./group.vue"
import { Child } from "./types";

defineProps<{
    child: Child;
}>()

defineEmits<{(e: "update:child", value: Child), (e: "delete")}>()
</script>
<style scoped>

.child {
    margin-left: 10px;
}
</style>