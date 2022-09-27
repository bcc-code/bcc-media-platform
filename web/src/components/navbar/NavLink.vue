<template>
    <router-link :to="to" class="lg:flex gap-2" v-slot="{isExactActive}">
        <img class="w-8 my-auto mx-auto" :src="iconFolder + (isExactActive ? '/Selected.svg' : '/Default.svg')" />
        <h1 class="my-auto text-center">
            <slot></slot>
        </h1>
    </router-link>
</template>
<script lang="ts" setup>
import { RouteLocationRaw } from 'vue-router';

defineProps<{
    to: RouteLocationRaw
    iconFolder: string
}>()
</script>
