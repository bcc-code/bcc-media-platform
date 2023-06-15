<script lang="ts" setup>
import { computed, ref } from "vue"

const props = defineProps<{
    modelValue?: string
    readonly?: boolean
    required?: boolean
}>()

const emit = defineEmits<{
    (e: "update:modelValue", v?: string): void
}>()

const updated = ref(false)

const value = computed({
    get() {
        return props.modelValue
    },
    set(v) {
        updated.value = true
        emit("update:modelValue", v)
    },
})
</script>

<template>
    <div class="flex flex-col gap-2">
        <label>
            <slot></slot>
            <span v-if="required" class="ml-1 text-red">*</span>
        </label>

        <input
            v-model="value"
            :readonly="readonly"
            type="text"
            class="p-2 px-4 rounded bg-bcc-2"
            :class="{
                'outline-red': required && updated && !value,
            }"
        />
    </div>
</template>
