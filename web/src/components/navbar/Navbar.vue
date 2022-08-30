<template>
    <div
        class="flex max-w-screen-lg mx-auto bg-gradient-to-r from-primary via-primary-light to-primary p-4"
    >
        <img class="h-16" src="/logo.svg" />
        <div class="flex my-auto ml-auto gap-4">
            <LoginButton>Logout</LoginButton>
            <VSelect v-model="selected" :data="languages">Language</VSelect>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { ref } from "vue";
import LoginButton from "../user/LoginButton.vue";
import VSelect from "../VSelect.vue";

const languages = [
    {
        title: "NO"
    },
    {
        title: "EN",
    },
    {
        title: "PL"
    }
]

const selected = ref(languages[0])
</script>
