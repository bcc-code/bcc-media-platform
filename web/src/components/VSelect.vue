<template>
    <div>
        <Listbox v-model="selected">
            <div class="relative mt-1">
                <ListboxButton
                    class="relative w-full cursor-default rounded-lg py-2 px-4 hover:bg-primary-light text-left shadow-md focus:outline-none focus-visible:border-indigo-500 focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75 focus-visible:ring-offset-2 focus-visible:ring-offset-orange-300 sm:text-sm">
                    <span class="block truncate">{{  selected.title  }}</span>
                </ListboxButton>

                <transition leave-active-class="transition duration-100 ease-in" leave-from-class="opacity-100"
                    leave-to-class="opacity-0">
                    <ListboxOptions
                        class="absolute mt-1 max-h-60 w-full rounded-md shadow-lg focus:outline-none sm:text-sm">
                        <ListboxOption v-slot="{ active, selected }" v-for="(item, i) in data" :key="i"
                            :value="item" as="template">
                            <li :class="[
                                active ? 'bg-primary-light text-amber-100' : 'text-gray-100',
                                'relative cursor-default select-none py-2 pl-4',
                            ]">
                                <span :class="[
                                    selected ? 'font-medium' : 'font-normal',
                                    'block truncate',
                                ]">{{  item.title  }}</span>
                            </li>
                        </ListboxOption>
                    </ListboxOptions>
                </transition>
            </div>
        </Listbox>
    </div>
</template>
  
<script lang="ts" setup>
import { computed } from 'vue'
import {
    Listbox,
    ListboxButton,
    ListboxOptions,
    ListboxOption,
} from '@headlessui/vue'

interface Value {
    title: string
}

const props = defineProps<{
    modelValue: Value,
    data: Value[],
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
    } 
})
</script>
  