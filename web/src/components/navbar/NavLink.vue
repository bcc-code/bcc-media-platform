<template>
    <router-link :to="to" class="lg:flex gap-2" v-slot="{ isExactActive }">
        <component
            v-if="icon"
            :is="icon"
            class="w-8 m-auto"
            :selected="isExactActive"
        ></component>
        <h1 class="my-auto text-center">
            <slot></slot>
        </h1>
    </router-link>
</template>
<script lang="ts" setup>
import { RouteLocationRaw } from "vue-router"

defineProps<{
    to: RouteLocationRaw
    icon?: any
}>()
</script>
