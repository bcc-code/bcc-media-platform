<template>
    <div>Redirecting to login...</div>
</template>
<script lang="ts" setup>
import { useAuth0 } from "@auth0/auth0-vue"
import { onMounted } from "vue"

const { loginWithRedirect } = useAuth0()

onMounted(() => {
    loginWithRedirect()
})
</script>
