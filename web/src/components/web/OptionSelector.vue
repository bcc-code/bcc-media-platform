<script lang="ts" setup>
import { computed, ref } from 'vue';

const props = defineProps<{
    modelValue: string;
    options: string[];
    allowAny: boolean;
}>()

const emit = defineEmits<{
    (e: 'update:modelValue', v: string): void;
}>();

const currentOption = ref<string>()

const optionValue = computed({
    get() {
        return currentOption.value
    },
    set(v) {
        currentOption.value = v
        if (v == 'Annet') {
            emit("update:modelValue", "");
        } else {
            emit("update:modelValue", v ?? "");
        }
    }
})
</script>

<template>
    <div class="flex flex-col gap-2">
        <label><slot></slot></label>
        <select class="p-2 px-4 rounded bg-background" v-model="optionValue">
            <option v-for="opt in options">{{ opt }}</option>
            <option v-if="allowAny">Annet</option>
        </select>
        <input v-if="currentOption === 'Annet'" :modelValue="modelValue" class="p-2 px-4 rounded bg-background" type="text" placeholder="..." />
    </div>
</template>