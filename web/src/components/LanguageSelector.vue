<script lang="ts" setup>
import { Language, current, languages, setLanguage } from "@/services/language"
import { Menu, MenuButton, MenuItem, MenuItems } from "@headlessui/vue"
</script>

<template>
    <Menu as="div" class="relative my-auto">
        <MenuButton
            :class="false ? '' : 'text-opacity-90'"
            class="flex hover:bg-bcc-2 transition rounded text-base px-2 p-1 font-medium text-white hover:text-opacity-100 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75"
        >
            <svg
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                class="w-8 h-8 fill-primary"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2ZM4.25203 10C4.08751 10.6392 4 11.3094 4 12C4 12.6906 4.08751 13.3608 4.25203 14H7.09432C7.03228 13.3521 7 12.6829 7 12C7 11.3171 7.03228 10.6479 7.09432 10H4.25203ZM5.07026 8H7.39317C7.60515 6.9765 7.89762 6.04022 8.25776 5.2299C8.31802 5.09431 8.38064 4.96122 8.44561 4.83099C7.03292 5.53275 5.8571 6.63979 5.07026 8ZM9.10446 10C9.03652 10.6376 9 11.3072 9 12C9 12.6928 9.03652 13.3624 9.10446 14H14.8955C14.9635 13.3624 15 12.6928 15 12C15 11.3072 14.9635 10.6376 14.8955 10H9.10446ZM14.5584 8H9.44164C9.61531 7.26765 9.83379 6.60826 10.0854 6.04218C10.4134 5.30422 10.778 4.76892 11.1324 4.43166C11.4816 4.0993 11.7731 4 12 4C12.2269 4 12.5184 4.0993 12.8676 4.43166C13.222 4.76892 13.5866 5.30422 13.9146 6.04218C14.1662 6.60826 14.3847 7.26765 14.5584 8ZM16.9057 10C16.9677 10.6479 17 11.3171 17 12C17 12.6829 16.9677 13.3521 16.9057 14H19.748C19.9125 13.3608 20 12.6906 20 12C20 11.3094 19.9125 10.6392 19.748 10H16.9057ZM18.9297 8H16.6068C16.3949 6.9765 16.1024 6.04022 15.7422 5.2299C15.682 5.09431 15.6194 4.96122 15.5544 4.83099C16.9671 5.53275 18.1429 6.63979 18.9297 8ZM8.44561 19.169C7.03292 18.4672 5.85709 17.3602 5.07026 16H7.39317C7.60515 17.0235 7.89762 17.9598 8.25776 18.7701C8.31802 18.9057 8.38064 19.0388 8.44561 19.169ZM10.0854 17.9578C9.83379 17.3917 9.61531 16.7324 9.44164 16H14.5584C14.3847 16.7324 14.1662 17.3917 13.9146 17.9578C13.5866 18.6958 13.222 19.2311 12.8676 19.5683C12.5184 19.9007 12.2269 20 12 20C11.7731 20 11.4816 19.9007 11.1324 19.5683C10.778 19.2311 10.4134 18.6958 10.0854 17.9578ZM15.7422 18.7701C16.1024 17.9598 16.3949 17.0235 16.6068 16H18.9297C18.1429 17.3602 16.9671 18.4672 15.5544 19.169C15.6194 19.0388 15.682 18.9057 15.7422 18.7701Z"
                />
            </svg>
            <p class="uppercase ml-1 my-auto">
                {{ current.code }}
            </p>
        </MenuButton>
        <transition
            enter-active-class="transition duration-200 ease-out"
            enter-from-class="translate-y-1 opacity-0"
            enter-to-class="translate-y-0 opacity-100"
            leave-active-class="transition duration-150 ease-in"
            leave-from-class="translate-y-0 opacity-100"
            leave-to-class="translate-y-1 opacity-0"
        >
            <MenuItems
                class="absolute right-0 mt-2 w-56 origin-top-right divide-y outline outline-bcc-1 divide-gray-100 rounded-md bg-bcc-2 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-10"
            >
                <div class="p-1 max-h-96 overflow-y-scroll">
                    <MenuItem v-slot="{ active }" v-for="l in languages">
                        <div
                            @click="setLanguage(l.code)"
                            :class="[
                                active ? 'bg-bcc text-white' : 'text-gray-900',
                                'w-full rounded-md px-2 py-2 text-sm transition duration-50 cursor-pointer',
                            ]"
                        >
                            <p class="text-base">
                                {{ l.name }}
                            </p>
                            <p v-if="l.localizedName" class="text-gray">
                                {{ l.localizedName }}
                            </p>
                        </div>
                    </MenuItem>
                </div>
            </MenuItems>
        </transition>
    </Menu>
</template>
