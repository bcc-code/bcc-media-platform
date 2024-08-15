<template>
    <div>
        <VButton v-if="authenticated" color="red" @click="signOut()">{{
            t("buttons.logout")
        }}</VButton>
        <VButton v-else color="secondary" @click="signIn()">{{
            t("buttons.login")
        }}</VButton>
    </div>
</template>
<script lang="ts" setup>
import Auth from "@/services/auth"
import { useI18n } from "vue-i18n"
import VButton from "../VButton.vue"

const { t } = useI18n()

const authenticated = Auth.isAuthenticated()
const signIn = Auth.signIn
const signOut = Auth.signOut
</script>
