<template>
    <div>
        <VButton v-if="isAuthenticated" theme="error">Logout</VButton>
        <VButton v-else theme="info">Login</VButton>
    </div>
</template>
<script lang="ts" setup>
import { useAuth0 } from "@auth0/auth0-vue"
import VButton from "../VButton.vue"

const { isAuthenticated } = useAuth0()
</script>
