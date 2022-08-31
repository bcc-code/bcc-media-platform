<template>
    <div
        class="flex max-w-screen-lg mx-auto bg-gradient-to-r from-primary via-primary-light to-primary p-4"
    >
        <img class="h-8" src="/logo.svg" />
        <div class="flex my-auto ml-auto gap-4">
            <LoginButton>Logout</LoginButton>
            <VSelect v-model="selected" :data="languages">Language</VSelect>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { computed, ref } from "vue"
import LoginButton from "../user/LoginButton.vue"
import VSelect from "../VSelect.vue"

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
