<script lang="ts" setup>
import { useAuth } from '@/services/auth'
import { VButton } from '..'
import Image from '../Image.vue'
import { useRouter } from 'vue-router'

const { signIn } = useAuth()

const router = useRouter()
</script>
<template>
    <div class="w-full flex">
        <div class="mx-auto max-w-lg text-center flex flex-col gap-2 mt-4">
            <h1 class="text-2xl font-bold">
                {{ $t('episode.noAccess.oops') }}
            </h1>
            <p>{{ $t('episode.noAccess.mustBeLoggedIn') }}</p>
            <Image
                class="rounded-xl"
                size-source="width"
                :ratio="9 / 16"
            ></Image>
            <p class="mt-4 opacity-80">
                {{ $t('episode.noAccess.otherContent') }}
            </p>
            <VButton class="w-full" @click="router.push('/')">{{
                $t('episode.noAccess.exploreContent')
            }}</VButton>
            <VButton class="w-full" color="green" @click="signIn()">{{
                $t('buttons.login')
            }}</VButton>
        </div>
    </div>
</template>
