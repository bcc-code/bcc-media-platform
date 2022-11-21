<template>
    <div>
        <Execute v-if="authenticated" :code="code"></Execute>
    </div>
</template>
<script lang="ts" setup>
import client from '@/graph/client';
import { useAuth } from '@/services/auth';
import { provideClient } from '@urql/vue';
import Execute from './Execute.vue';
provideClient(client)

defineProps<{code: string}>();

const { authenticated } = useAuth();
</script>