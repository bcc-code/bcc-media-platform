<template>
    <Listbox as="div" v-model="selectedItem" class="mb-2 font-medium">
        <div class="relative mt-1">
            <ListboxButton
                class="relative w-full border-0 cursor-default rounded-md border py-2 pl-3 pr-10 text-left shadow-sm text-style-button-2"
            >
                <span class="flex items-center">
                    <span class="block truncate uppercase">{{
                        selected?.title
                    }}</span>
                    <ChevronDown
                        class="text-gray-400 stroke-white"
                        aria-hidden="true"
                    />
                </span>
            </ListboxButton>
            <transition
                leave-active-class="transition ease-in duration-100"
                leave-from-class="opacity-100"
                leave-to-class="opacity-0"
            >
                <ListboxOptions
                    class="absolute z-10 mt-1 max-h-56 w-full overflow-auto rounded-md bg-slate-900 py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none text-style-button-2"
                >
                    <ListboxOption
                        as="template"
                        v-for="s in items"
                        :key="s.id"
                        :value="s.id"
                        v-slot="{ active, selected }"
                    >
                        <li
                            :class="[
                                active ? 'text-white bg-primary' : 'opacity-80',
                                'relative cursor-default select-none bg-opacity-20 py-2 pl-3 pr-9',
                            ]"
                        >
                            <div class="flex items-center">
                                <span
                                    :class="[
                                        selected
                                            ? 'font-semibold'
                                            : 'font-normal',
                                        'ml-3 block truncate uppercase',
                                    ]"
                                    >{{ s.title }}</span
                                >
                            </div>
                        </li>
                    </ListboxOption>
                </ListboxOptions>
            </transition>
        </div>
    </Listbox>
</template>
<script lang="ts" setup>
import {
    Listbox,
    ListboxButton,
    ListboxOption,
    ListboxOptions,
} from "@headlessui/vue"
import { computed, ref } from "vue"
import { ChevronDown } from "./icons"

const props = defineProps<{
    modelValue: string
    items: {
        id: string
        title: string
    }[]
}>()

const emit = defineEmits<{
    (e: "update:modelValue", i: string): void
}>()

const selectedItem = computed({
    get() {
        return props.modelValue
    },
    set(v) {
        emit("update:modelValue", v)
    },
})

const selected = computed(() => {
    return props.items.find((i) => i.id === props.modelValue)
})
</script>
