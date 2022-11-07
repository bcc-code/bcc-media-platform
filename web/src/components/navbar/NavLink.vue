<template>
    <router-link
        :to="to"
        class="rounded-full my-auto"
        v-slot="{ isExactActive }"
    >
        <div class="lg:flex gap-1 transition rounded-full lg:hover:bg-slate-800 px-2" :class="[isExactActive ? 'lg:bg-slate-800 lg:bg-opacity-50' : '']">
            <component
                :is="icon"
                class="w-8 h-8 m-auto"
                :selected="isExactActive"
            ></component>
            <h1 class="my-auto text-center">
                <slot></slot>
            </h1>
        </div>
    </router-link>
</template>
<script lang="ts" setup>
import { RouteLocationRaw } from "vue-router"

defineProps<{
    to: RouteLocationRaw
    icon?: any
}>()
</script>
