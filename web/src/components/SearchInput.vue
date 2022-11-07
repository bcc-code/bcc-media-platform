<template>
    <div class="relative flex" :class="[disabled ? 'opacity-50' : '']">
        <SearchIcon
            class="absolute pointer-events-none left-0 inset-y-0 my-auto ml-2"
        ></SearchIcon>
        <input
            v-model="value"
            type="text"
            :disabled="disabled"
            class="pl-10 w-full bg-slate-800 rounded-full pr-16 p-2 my-auto text-md"
            :class="[disabled ? 'text-gray' : '']"
            :placeholder="t('page.search')"
            @keydown.enter="emit('keydown.enter')"
        />
        <p v-if="value" class="absolute flex right-2 px-2 inset-y-2 cursor-pointer text-sm opacity-50 bg-slate-700 rounded-full" @click="value = ''"><span class="my-auto">Cancel</span></p>
    </div>    
</template>
<script lang="ts" setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { SearchIcon } from './icons';

const { t } = useI18n()

const props = defineProps<{
    modelValue: any
    disabled?: boolean
}>()

const emit = defineEmits<{
    (e: "update:modelValue", value: any): void
    (e: "keydown.enter"): void
}>()

const value = computed({
    get() {
        return props.modelValue;
    },
    set(v)  {
        emit("update:modelValue", v)
    }
})
</script>