<template>
    <div class="relative invisible md:visible p-4">
        <div class="absolute right-4 flex">
            <div class="flex ml-auto my-auto gap-4">
                <LoginButton>Logout</LoginButton>
                <VSelect v-model="selected" :data="languages">Language</VSelect>
            </div>
        </div>
        <img
            @click="home()"
            class="h-8 mx-auto cursor-pointer"
            src="/logo.svg"
        />
    </div>
</template>
<script lang="ts" setup>
import { computed, ref } from "vue"
import { useRouter } from "vue-router"
import LoginButton from "../user/LoginButton.vue"
import VSelect from "../VSelect.vue"

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
            code: i.title,
            title: languageNames.of(i.code) ?? "unknown",
        }))
    }
    return _languages
})

const selected = ref(languages.value[0])
</script>
