<template>
    <div class="flex h-screen w-screen">
        <Execute
            class="h-full w-full"
            v-if="authenticated"
            :code="code"
        ></Execute>
        <button v-else @click="signIn()" class="mx-auto my-auto">
            {{ $t("buttons.login") }}
        </button>
    </div>
</template>
<script lang="ts" setup>
import client from "@/graph/client"
import { useAuth } from "@/services/auth"
import { provideClient } from "@urql/vue"
import Execute from "./Execute.vue"
provideClient(client)

defineProps<{ code: string }>()

const { authenticated, signIn } = useAuth()
</script>
