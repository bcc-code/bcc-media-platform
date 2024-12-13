<script lang="ts" setup>
import client from '@/graph/client'
import { useAuth } from '@/services/auth'
import { provideClient } from '@urql/vue'
import Execute from './Execute.vue'
import { useI18n } from 'vue-i18n'
provideClient(client)

defineProps<{ code: string }>()

const { authenticated, signIn } = useAuth()
const { t } = useI18n()
</script>
<template>
    <div class="flex h-screen w-screen">
        <Execute
            v-if="authenticated"
            class="h-full w-full"
            :code="code"
        ></Execute>
        <button v-else class="mx-auto my-auto" @click="signIn()">
            {{ t('buttons.login') }}
        </button>
    </div>
</template>
