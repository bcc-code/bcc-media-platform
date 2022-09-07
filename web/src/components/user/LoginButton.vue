<template>
    <div>
        <VButton v-if="authenticated" @click="signOut()" color="red"
            >Logout</VButton
        >
        <VButton v-else @click="signIn()" color="secondary">Login</VButton>
    </div>
</template>
<script lang="ts" setup>
import Auth from "@/services/auth"
import VButton from "../VButton.vue"

const authenticated = Auth.isAuthenticated()
const signIn = Auth.signIn
const signOut = Auth.signOut
</script>
