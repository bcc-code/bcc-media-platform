<template>
    <router-link :to="to" class="flex" v-slot="{isExactActive}">
        <img class="w-8 my-auto" :src="iconFolder + (isExactActive ? '/Selected.svg' : '/Default.svg')" />
        <h1 class="ml-2 my-auto">
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