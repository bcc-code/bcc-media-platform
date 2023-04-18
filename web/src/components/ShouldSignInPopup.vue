<script lang="ts" setup>
import { useAuth } from "@/services/auth"
const { shouldSignIn, signIn, cancelSignIn } = useAuth()
</script>
<template>
    <div v-if="shouldSignIn()">
        <div
            class="fixed inset-0 flex text-2xl w-full h-full bg-black bg-opacity-50 z-50 bg-blur backdrop-blur-sm fixed"
        >
            <div
                class="mx-auto my-auto flex flex-col bg-background p-4 rounded-lg gap-4"
            >
                <h1 class="text-xl text-center mb-2 mt-2">
                    {{ $t("dashboard.loggedOut") }}
                </h1>
                <div class="flex gap-2">
                    <button
                        class="ml-auto text-lg px-2 py-1 bg-primary rounded-lg hover:scale-105"
                        @click="signIn()"
                    >
                        {{ $t("buttons.login") }}
                    </button>
                    <button
                        class="text-lg px-2 py-1 bg-slate-800 rounded-lg hover:scale-105"
                        @click="cancelSignIn()"
                    >
                        {{ $t("buttons.stayLoggedOut") }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
