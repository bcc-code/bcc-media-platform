<script lang="ts" setup>
import { MenuItems, MenuItem } from "@headlessui/vue"
</script>

<template>
    <MenuItems
        class="w-[378px] absolute right-0 mt-2 w-56 origin-top-right divide-y divide-gray-100 rounded-md bg-slate-700 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-10"
    >
        <div class="p-1">
            <div class="flex justify-center text-xl font-bold">Language</div>
            <div class="m-[16px]">
                <div class="mx-4 my-2 text-xs text-[#EBEBF599]">LANGUAGE</div>
                <MenuItem v-slot="{ active }" @click="">
                    <button
                        :class="[
                            active
                                ? 'bg-[#EBEBF599] text-white'
                                : 'text-gray-900 bg-[#1D2838]',
                            'w-full rounded-t-lg px-4 py-[16px] text-sm transition duration-50 cursor-pointer flow-root',
                        ]"
                    >
                        <div class="text-white float-left">Site language</div>
                        <div class="text-[#EBEBF599] float-right">
                            English (English)<span class="text-[#EBEBF599] ml-2"
                                >&#x3e;
                            </span>
                        </div>
                    </button>
                </MenuItem>

                <MenuItem v-slot="{ active }">
                    <button
                        :class="[
                            active
                                ? 'bg-[#EBEBF599] text-white'
                                : 'text-gray-900 bg-[#1D2838]',
                            'w-full px-4 py-[16px] text-sm transition duration-50 cursor-pointer flow-root',
                        ]"
                    >
                        <span class="text-white float-left"
                            >Audio language</span
                        >
                        <ul class="text-[#EBEBF599] float-right">
                            Norsk (Norwegian)<span class="text-[#EBEBF599] ml-2"
                                >&#x3e;
                            </span>
                        </ul>
                    </button>
                </MenuItem>
                <MenuItem v-slot="{ active }">
                    <button
                        :class="[
                            active
                                ? 'bg-[#EBEBF599] text-white'
                                : 'text-gray-900 bg-[#1D2838]',
                            'w-full rounded-b-lg px-4 py-[16px] text-sm transition duration-50 cursor-pointer flow-root',
                        ]"
                    >
                        <span class="text-white float-left"
                            >Subtitle language</span
                        >
                        <ul class="text-[#EBEBF599] float-right">
                            English (English)<span class="text-[#EBEBF599] ml-2"
                                >&#x3e;
                            </span>
                        </ul>
                    </button>
                </MenuItem>
            </div>
        </div>
    </MenuItems>
</template>
