<script lang="ts" setup>
import { computed } from "vue"

const props = defineProps<{
    modelValue?: string
}>()

const emit = defineEmits<{
    (e: "update:modelValue", v?: string): void
}>()

const value = computed({
    get() {
        return props.modelValue
    },
    set(v) {
        emit("update:modelValue", v)
    },
})
</script>

<template>
    <div class="flex flex-col gap-2">
        <label>
            <slot></slot>
        </label>

        <input
            v-model="value"
            type="date"
            class="p-2 px-4 rounded bg-background"
        />
    </div>
</template>
