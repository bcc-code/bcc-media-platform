<template>
    <div class="flex md:visible p-4">
        <div class="ml-auto flex">
            <div class="flex ml-auto my-auto gap-4">
                <NavLink 
                    :to="{ name: 'front-page' }" 
                    icon-folder="/icons/TabBar/Home"
                >
                    Home
                </NavLink>
                <NavLink 
                    :to="{ name: 'search' }" 
                    icon-folder="/icons/TabBar/Search"
                >
                    Search
                </NavLink>
                <NavLink 
                    :to="{ name: 'front-page' }" 
                    icon-folder="/icons/TabBar/Live"
                >
                    Live
                </NavLink>
                <NavLink 
                    :to="{ name: 'front-page' }" 
                    icon-folder="/icons/TabBar/Calendar"
                >
                    Calendar
                </NavLink>
                <NavLink 
                    :to="{ name: 'front-page' }" 
                    icon-folder="/icons/TabBar/Feed"
                >
                    FAQ
                </NavLink>
                <LoginButton></LoginButton>
                <VSelect v-model="selected" :data="languages">Language</VSelect>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import i18n, { loadLocaleMessages, setLanguage } from "@/i18n"
import settings from "@/services/settings"
import { computed, ref, watch } from "vue"
import { useI18n } from "vue-i18n"
import { useRouter } from "vue-router"
import LoginButton from "../user/LoginButton.vue"
import VSelect from "../VSelect.vue"
import NavLink from "./NavLink.vue"

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
