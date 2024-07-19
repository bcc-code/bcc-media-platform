<template>
    <div>
        <Listbox v-model="selected">
            <div class="relative">
                <ListboxButton
                    class="cursor-pointer rounded-full border border-gray bg-secondary py-2 px-3 text-left shadow-sm hover:border-indigo-500 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 sm:text-sm"
                >
                    <span class="flex items-center">
                        <span class="block truncate">{{ selected.title }}</span>
                    </span>
                </ListboxButton>

                <transition
                    leave-active-class="transition duration-100 ease-in"
                    leave-from-class="opacity-100"
                    leave-to-class="opacity-0"
                >
                    <ListboxOptions
                        class="absolute bg-secondary z-10 mt-1 max-h-60 right-0 rounded-md shadow-lg sm:text-sm overflow-auto"
                    >
                        <ListboxOption
                            v-slot="{ active, selected }"
                            v-for="(item, i) in data"
                            :key="i"
                            :value="item"
                            as="template"
                        >
                            <li
                                :class="[
                                    active
                                        ? 'bg-primary text-amber-100'
                                        : 'text-gray-100',
                                    'relative cursor-pointer select-none py-2 px-4',
                                ]"
                            >
                                <span
                                    :class="[
                                        selected
                                            ? 'font-medium'
                                            : 'font-normal',
                                        'block truncate',
                                    ]"
                                    >{{ item.title }}</span
                                >
                            </li>
                        </ListboxOption>
                    </ListboxOptions>
                </transition>
            </div>
        </Listbox>
    </div>
</template>

<script lang="ts" setup>
import { computed } from "vue"
import {
    Listbox,
    ListboxButton,
    ListboxOptions,
    ListboxOption,
} from "@headlessui/vue"

interface Value {
    title: string
}

const props = defineProps<{
    modelValue: Value
    data: Value[]
}>()
const emit = defineEmits<{
    (e: "update:modelValue", i: Value): any
}>()

const selected = computed({
    get() {
        return props.modelValue
    },
    set(v: Value) {
        emit("update:modelValue", v)
    },
})
</script>
