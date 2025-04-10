<script lang="ts" setup>
import client from '@/graph/client'
import { useAuth } from '@/services/auth'
import { provideClient } from '@urql/vue'
import Execute from './Execute.vue'
import { useI18n } from 'vue-i18n'
import { VButton } from '@/components'
import { ArrowRightIcon } from '@heroicons/vue/16/solid'
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
        <VButton
            v-else
            class="mx-auto my-auto flex gap-2 items-center pl-6"
            color="secondary"
            @click="() => signIn()"
        >
            {{ t('buttons.login') }}
            <ArrowRightIcon class="size-5 opacity-60" />
        </VButton>
    </div>
</template>
