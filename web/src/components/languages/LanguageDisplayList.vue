<script lang="ts" setup>
import { current, setLanguage, languages, Language } from "@/services/language"
import {
    MenuItems,
    MenuItem,
} from "@headlessui/vue"
import { computed, PropType, toRef } from "vue";
import { LanguageMenu } from "./LanguageDisplay.vue";


const props = defineProps<{
    data: LanguageMenu[],
    headerTitle?: string,
    isMenuDisplay?: Boolean
}>()

// const emits = defineEmits(['Clicked'])


defineEmits<{
    (e: "clickPage", value: string): void
}>()

const localData = toRef(props, 'data')

const getLanguage = (code: string) => {
    return languages.value.find((item) => item.code == code)
}

// const props = defineProps({
//   data: {
//     type: Array as PropType<Array<LanguageMenu>>,
//     required: true
//   }
// })

// const props = defineProps({
//   title: String,
//   data: Object as PropType<LanguageMenu>
// }) 


</script>

<template>
    <MenuItems
        class="w-[378px] absolute right-0 mt-2 w-58 origin-top-right divide-y divide-gray-100 rounded-md bg-slate-700 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-10">
        <div class="p-1">
            <button v-if="!isMenuDisplay" class="absolute left-4"> &#8592 Back</button>
            <div class="flex justify-center text-xl font-bold">{{ headerTitle }}</div>
            <div class="m-[16px]">
                <!-- <slot name="header">
          &#8592
        </slot> -->
                <div class="mx-4 my-2 text-xs text-[#EBEBF599]">{{ headerTitle }}</div>
                <MenuItem v-slot="{ active, close }" v-for="item in localData">
                <button @click="$emit(`clickPage`, item.title)" :class="[
                    active
                        ? 'bg-[#EBEBF599] text-white'
                        : 'text-gray-900 bg-[#1D2838]',
                    'w-full px-4 py-[16px] text-sm transition duration-50 cursor-pointer flow-root',
                    localData.findIndex((el) => el.title == item.title) == 0 ? 'rounded-t-lg' :
                        localData.findIndex((el) => el.title == item.title) == localData.length - 1 ? 'rounded-b-lg' : '',
                ]">

                    <div>isMenuDisplay:{{ isMenuDisplay }}</div>

                    <div class="text-white float-left">{{ item.title }}</div>
                    <div class="text-[#EBEBF599] float-right">
                        <span>{{ getLanguage(item.selectedLang)?.name }}</span>
                        <span v-if="!!getLanguage(item.selectedLang)?.english">{{ ' (' +
                                getLanguage(item.selectedLang)?.english + ')'
                        }}</span>
                        <span class=" text-[#EBEBF599] ml-2">&#x3e;
                        </span>
                    </div>
                </button>
                </MenuItem>
            </div>
        </div>
    </MenuItems>
</template>