<template>
    <Disclosure as="nav" v-slot="{ open }">
        <div class="mx-auto px-2 lg:px-8">
            <div class="lg:flex py-4">
                <div class="flex mx-auto">
                    <div class="flex flex-shrink-0 my-auto">
                        <img
                            @click="$router.push({ name: 'front-page' })"
                            class="hidden h-8 w-auto lg:block cursor-pointer hover:scale-105 transition"
                            src="/logo.svg"
                            alt="BrunstadTV"
                        />
                    </div>
                    <div class="hidden lg:flex ml-6 my-auto space-x-2">
                        <div v-for="item in navigation" class="relative">
                            <NavLink
                                :icon="item.icon"
                                :to="item.to"
                                :ping="item.ping"
                            >
                                {{ t(item.name) }}</NavLink
                            >
                        </div>
                        <SearchInput
                            v-model="query"
                            @keydown="
                                $route.name !== 'search'
                                    ? $router.push({ name: 'search' })
                                    : null
                            "
                        ></SearchInput>
                    </div>
                    <div class="hidden lg:flex ml-2">
                    </div>
                    <div class="hidden lg:flex ml-2">
                        <LanguageSetting :open="open" />
                        <Menu as="div" class="relative my-auto ml-2">
                            <div>
                                <MenuButton
                                    :class="open ? '' : 'text-opacity-90'"
                                    class="flex hover:scale-110 transition rounded-md text-base font-medium text-white hover:text-opacity-100 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75"
                                >
                                    <img
                                        class="w-8 h-8 rounded rounded-full overflow-hidden stroke-primary"
                                        v-if="authenticated && user.picture"
                                        :src="user.picture"
                                    />
                                    <ProfileIcon
                                        v-else
                                        class="w-8 h-8 stroke-primary"
                                    ></ProfileIcon>
                                </MenuButton>
                            </div>
                            <transition
                                enter-active-class="transition duration-200 ease-out"
                                enter-from-class="translate-y-1 opacity-0"
                                enter-to-class="translate-y-0 opacity-100"
                                leave-active-class="transition duration-150 ease-in"
                                leave-from-class="translate-y-0 opacity-100"
                                leave-to-class="translate-y-1 opacity-0"
                            >
                                <MenuItems
                                    class="absolute text-base right-0 mt-2 w-56 origin-top-right divide-y divide-gray-100 rounded-md bg-slate-800 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-10"
                                >
                                    <div class="p-1">
                                        <MenuItem v-slot="{ active }">
                                            <button
                                                @click="
                                                    authenticated
                                                        ? signOut()
                                                        : signIn()
                                                "
                                                :class="[
                                                    active
                                                        ? 'bg-violet-500 text-white'
                                                        : 'text-gray-900',
                                                    'flex w-full rounded-md px-2 py-2 text-sm items-center transition duration-50',
                                                ]"
                                            >
                                                <ProfileIcon
                                                    class="stroke-red-500"
                                                ></ProfileIcon>

                                                <p class="ml-2 text-base">
                                                    {{
                                                        t(
                                                            "buttons." +
                                                                (authenticated
                                                                    ? "logout"
                                                                    : "login")
                                                        )
                                                    }}
                                                </p>
                                            </button>
                                        </MenuItem>
                                        <MenuItem v-slot="{ active }">
                                            <button
                                                :class="[
                                                    active
                                                        ? 'bg-violet-500 text-white'
                                                        : 'text-gray-900',
                                                    'flex w-full rounded-md px-2 py-2 text-sm items-center transition duration-50',
                                                ]"
                                            >
                                                <SettingsIcon
                                                    class="h-6"
                                                ></SettingsIcon>
                                                <p class="ml-2 text-base">
                                                    Settings
                                                </p>
                                            </button>
                                        </MenuItem>
                                    </div>
                                </MenuItems>
                            </transition>
                        </Menu>
                    </div>
                </div>
                
                <div class="flex lg:hidden mx-4">
                    <img
                        class="h-8 w-auto mb-4"
                        src="/logo.svg"
                        alt="Your Company"
                    />
                    <div class="ml-auto right-4 flex">
                        <div class="lg:hidden flex ml-2">
                            <LanguageSetting :open="open" />
                        </div>
                        <Menu as="div" class="relative my-auto ml-2">
                            <div>
                                <MenuButton
                                    :class="open ? '' : 'text-opacity-90'"
                                    class="flex rounded-md text-base font-medium text-white hover:text-opacity-100 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75"
                                >
                                    <img
                                        class="w-8 h-8 rounded rounded-full overflow-hidden stroke-primary"
                                        v-if="authenticated && user.picture"
                                        :src="user.picture"
                                    />
                                    <ProfileIcon
                                        v-else
                                        class="w-8 h-8 stroke-primary"
                                    ></ProfileIcon>
                                </MenuButton>
                            </div>
                            <transition
                                enter-active-class="transition duration-200 ease-out"
                                enter-from-class="translate-y-1 opacity-0"
                                enter-to-class="translate-y-0 opacity-100"
                                leave-active-class="transition duration-150 ease-in"
                                leave-from-class="translate-y-0 opacity-100"
                                leave-to-class="translate-y-1 opacity-0"
                            >
                                <MenuItems
                                    class="absolute text-base right-0 mt-2 w-56 origin-top-right divide-y divide-gray-100 rounded-md bg-slate-800 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-10"
                                >
                                    <div class="p-1">
                                        <MenuItem v-slot="{ active }">
                                            <button
                                                @click="
                                                    authenticated
                                                        ? signOut()
                                                        : signIn()
                                                "
                                                :class="[
                                                    active
                                                        ? 'bg-violet-500 text-white'
                                                        : 'text-gray-900',
                                                    'flex w-full rounded-md px-2 py-2 text-sm items-center transition duration-50',
                                                ]"
                                            >
                                                <ProfileIcon
                                                    class="stroke-red-500"
                                                ></ProfileIcon>

                                                <p class="ml-2 text-base">
                                                    {{
                                                        t(
                                                            "buttons." +
                                                                (authenticated
                                                                    ? "logout"
                                                                    : "login")
                                                        )
                                                    }}
                                                </p>
                                            </button>
                                        </MenuItem>
                                        <MenuItem v-slot="{ active }">
                                            <button
                                                :class="[
                                                    active
                                                        ? 'bg-violet-500 text-white'
                                                        : 'text-gray-900',
                                                    'flex w-full rounded-md px-2 py-2 text-sm items-center transition duration-50',
                                                ]"
                                            >
                                                <SettingsIcon
                                                    class="h-6"
                                                ></SettingsIcon>
                                                <p class="ml-2 text-base">
                                                    Settings
                                                </p>
                                            </button>
                                        </MenuItem>
                                    </div>
                                </MenuItems>
                            </transition>
                        </Menu>
                    </div>
                </div>
                <div class="flex lg:hidden justify-between mx-8">
                    <NavLink
                        v-for="item in navigation"
                        :to="item.to"
                        :icon="item.icon"
                        :ping="item.ping"
                    >
                        {{ t(item.name) }}
                    </NavLink>
                    <NavLink :icon="SearchIcon" :to="{ name: 'search' }">
                        {{ t("page.search") }}</NavLink
                    >
                </div>
            </div>
        </div>
    </Disclosure>
</template>
<script lang="ts" setup>
import { RouteLocationRaw } from "vue-router"
import NavLink from "./NavLink.vue"
import {
    Disclosure,
    Menu,
    MenuButton,
    MenuItems,
    MenuItem,
} from "@headlessui/vue"
import { useAuth } from "@/services/auth"
import { useI18n } from "vue-i18n"
import { current, setLanguage, languages } from "@/services/language"
import {
    CalendarIcon,
    HomeIcon,
    LiveIcon,
    ProfileIcon,
    SearchIcon,
    SettingsIcon,
} from "../icons"
import { computed } from "vue"
import SearchInput from "../SearchInput.vue"
import { useSearch } from "@/utils/search"
import { useGetCalendarStatusQuery } from "@/graph/generated"
import LanguageSetting from "../languages/LanguageSetting.vue"

const { t } = useI18n()

const { query } = useSearch()

const { authenticated, signOut, signIn, user } = useAuth()

const navigation = computed(() => {
    const n: {
        name: string
        to: RouteLocationRaw
        icon?: any
        ping?: boolean
    }[] = [
        {
            name: "page.home",
            to: {
                name: "front-page",
            },
            icon: HomeIcon,
        },
    ]

    if (authenticated.value) {
        n.push({
            name: "page.live",
            to: {
                name: "live",
            },
            icon: LiveIcon,
            ping: isLive.value,
        })
    }

    n.push(
        ...[
            {
                name: "page.calendar",
                to: {
                    name: "calendar",
                },
                icon: CalendarIcon,
            },
        ]
    )

    return n
})

const { data } = useGetCalendarStatusQuery({
    variables: {
        day: new Date(),
    },
})

const isLive = computed(() => {
    const now = new Date()
    return (
        data.value?.calendar?.day.entries.some(
            (i) => new Date(i.start) < now && new Date(i.end) > now
        ) === true
    )
})
</script>
