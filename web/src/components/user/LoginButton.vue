<template>
    <div>
        <VButton v-if="authenticated" theme="error">Logout</VButton>
        <VButton v-else @click="signIn()" theme="info">Login</VButton>
    </div>
</template>
<script lang="ts" setup>
import Auth from "@/services/auth"
import VButton from "../VButton.vue"

const authenticated = Auth.isAuthenticated();
const signIn = Auth.signIn;
</script>
