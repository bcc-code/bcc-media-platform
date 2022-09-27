<template>
    <Disclosure as="nav" class="bg-gray-800" v-slot="{ open }">
        <div class="mx-auto max-w-7xl px-2 sm:px-6 lg:px-8">
            <div class="lg:flex h-16 items-center justify-between">
                <div
                    class="flex mx-auto items-center sm:items-stretch sm:justify-start"
                >
                    <div class="flex flex-shrink-0 items-center">
                        <!-- <img
                            class="block h-8 w-auto lg:hidden"
                            src="/logo.svg"
                            alt="Your Company"
                        /> -->
                        <img
                            class="hidden h-8 w-auto lg:block"
                            src="/logo.svg"
                            alt="Your Company"
                        />
                    </div>
                    <div class="hidden lg:ml-6 lg:block">
                        <div class="flex space-x-4">
                            <NavLink v-for="item in navigation" :icon-folder="item.iconFolder" :to="item.to">{{item.name}}</NavLink>
                        </div>
                    </div>
                </div>
                <div
                    class="flex lg:hidden"
                >

                    <img
                        class="h-8 w-auto"
                        src="/logo.svg"
                        alt="Your Company"
                    />
                </div>
                <div
                    class="flex lg:hidden"
                >
                    <div class="mx-auto flex space-x-4">
                        <NavLink v-for="item in navigation" :icon-folder="item.iconFolder" :to="item.to">{{item.name}}</NavLink>
                    </div>
                    <!-- Mobile menu button-->
                    <!-- <DisclosureButton
                        class="inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-700 hover:text-white focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                    >
                        <span class="sr-only">Open main menu</span>
                        <Bars3Icon
                            v-if="!open"
                            class="block h-6 w-6"
                            aria-hidden="true"
                        />
                        <XMarkIcon
                            v-else
                            class="block h-6 w-6"
                            aria-hidden="true"
                        />
                    </DisclosureButton> -->
                </div>
                <!-- <div
                    class="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0"
                >
                    <button
                        type="button"
                        class="rounded-full bg-gray-800 p-1 text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800"
                    >
                        <span class="sr-only">View notifications</span>
                        <BellIcon class="h-6 w-6" aria-hidden="true" />
                    </button>

                    <Menu as="div" class="relative ml-3">
                        <div>
                            <MenuButton
                                class="flex rounded-full bg-gray-800 text-sm focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800"
                            >
                                <span class="sr-only">Open user menu</span>
                                <img
                                    class="h-8 w-8 rounded-full"
                                    src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                    alt=""
                                />
                            </MenuButton>
                        </div>
                        <transition
                            enter-active-class="transition ease-out duration-100"
                            enter-from-class="transform opacity-0 scale-95"
                            enter-to-class="transform opacity-100 scale-100"
                            leave-active-class="transition ease-in duration-75"
                            leave-from-class="transform opacity-100 scale-100"
                            leave-to-class="transform opacity-0 scale-95"
                        >
                            <MenuItems
                                class="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
                            >
                                <MenuItem v-slot="{ active }">
                                    <a
                                        href="#"
                                        :class="[
                                            active ? 'bg-gray-100' : '',
                                            'block px-4 py-2 text-sm text-gray-700',
                                        ]"
                                        >Your Profile</a
                                    >
                                </MenuItem>
                                <MenuItem v-slot="{ active }">
                                    <a
                                        href="#"
                                        :class="[
                                            active ? 'bg-gray-100' : '',
                                            'block px-4 py-2 text-sm text-gray-700',
                                        ]"
                                        >Settings</a
                                    >
                                </MenuItem>
                                <MenuItem v-slot="{ active }">
                                    <a
                                        href="#"
                                        :class="[
                                            active ? 'bg-gray-100' : '',
                                            'block px-4 py-2 text-sm text-gray-700',
                                        ]"
                                        >Sign out</a
                                    >
                                </MenuItem>
                            </MenuItems>
                        </transition>
                    </Menu>
                </div> -->
            </div>
        </div>

        <!-- <DisclosurePanel class="sm:hidden">
            <div class="flex space-y-1 px-2 pt-2 pb-3">
                <NavLink v-for="item in navigation" :icon-folder="item.iconFolder" :to="item.to">{{item.name}}</NavLink>
            </div>
        </DisclosurePanel> -->
    </Disclosure>
</template>
<script lang="ts" setup>
import i18n, { loadLocaleMessages, setLanguage } from "@/i18n"
import settings from "@/services/settings"
import { computed, ref, watch } from "vue"
import { useI18n } from "vue-i18n"
import { RouteLocationRaw, useRouter } from "vue-router"
import NavLink from "./NavLink.vue"
import {
    Disclosure,
} from "@headlessui/vue"

const navigation: {
    name: string
    to: RouteLocationRaw,
    iconFolder: string
}[] = [
    { 
        name: "Home",
        to: {
            name: "front-page"
        },
        iconFolder: "/icons/TabBar/Home"
    },
    { 
        name: "Search",
        to: {
            name: "search"
        },
        iconFolder: "/icons/TabBar/Search"
    },
    { 
        name: "Live",
        to: {
            name: "front-page"
        },
        iconFolder: "/icons/TabBar/Live"
    },
    { 
        name: "Calendar",
        to: {
            name: "calendar"
        },
        iconFolder: "/icons/TabBar/Calendar"
    },
    { 
        name: "FAQ",
        to: {
            name: "front-page"
        },
        iconFolder: "/icons/TabBar/Feed"
    },
]

const { t } = useI18n()

const router = useRouter()

const home = () => router.push({ name: "front-page" })

const _languages = [
    {
        code: "no",
        title: "NO",
    },
    {
        code: "en",
        title: "EN",
    },
    {
        code: "pl",
        title: "PL",
    },
]

const languages = computed(() => {
    if (Intl !== undefined) {
        const languageNames = new Intl.DisplayNames(["en"], {
            type: "language",
        })
        return _languages.map((i) => ({
            code: i.code,
            title: languageNames.of(i.code) ?? "unknown",
        }))
    }
    return _languages
})

const selected = ref(
    languages.value.find((i) => i.code === settings.locale) ?? {
        title: "English",
        code: "en",
    }
)

watch(
    () => selected.value,
    async () => {
        await loadLocaleMessages(i18n, selected.value.code)
        setLanguage(i18n, selected.value.code)
        settings.locale = selected.value.code
    }
)
</script>
