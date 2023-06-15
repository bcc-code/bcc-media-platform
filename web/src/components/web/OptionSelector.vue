<script lang="ts" setup>
import { computed, ref } from "vue"
import { useI18n } from "vue-i18n"

const props = defineProps<{
    modelValue: string
    options: string[]
    allowAny: boolean
    required?: boolean
}>()

const emit = defineEmits<{
    (e: "update:modelValue", v: string): void
}>()

const currentOption = ref<string>()

const { t } = useI18n()

const updated = ref(false)

const optionValue = computed({
    get() {
        return currentOption.value
    },
    set(v) {
        currentOption.value = v
        if (v == t("requests.other")) {
            value.value = ""
        } else {
            value.value = v ?? ""
        }
    },
})

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
        <label><slot></slot></label>
        <select
            class="p-2 px-4 rounded bg-bcc-2"
            :class="{
                'outline outline-1 outline-red':
                    required && updated && !optionValue,
            }"
            v-model="optionValue"
        >
            <option v-for="opt in options">{{ opt }}</option>
            <option v-if="allowAny">{{ $t("requests.other") }}</option>
        </select>
        <input
            v-if="currentOption === $t('requests.other')"
            v-model="value"
            class="p-2 px-4 rounded bg-bcc-2"
            :class="{
                'outline outline-1 outline-red': required && updated && !value,
            }"
            type="text"
            placeholder="..."
        />
    </div>
</template>
