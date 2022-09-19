<template>
    <div>
        <VButton v-if="authenticated" @click="signOut()" color="red"
            >{{t("buttons.logout")}}</VButton
        >
        <VButton v-else @click="signIn()" color="secondary">{{t("buttons.login")}}</VButton>
    </div>
</template>
<script lang="ts" setup>
import Auth from "@/services/auth"
import { useI18n } from "vue-i18n";
import VButton from "../VButton.vue"

const {t} = useI18n();

const authenticated = Auth.isAuthenticated()
const signIn = Auth.signIn
const signOut = Auth.signOut
</script>
