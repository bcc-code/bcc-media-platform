<script lang="ts" setup>
import { RouteLocationRaw } from 'vue-router'

defineProps<{
    to: RouteLocationRaw
    icon?: any
}>()
</script>

<template>
    <router-link
        v-slot="{ isExactActive }"
        :to="to"
        class="rounded-full my-auto focus-visible:ring-2 focus-visible:ring-white/75"
    >
        <span
            class="lg:flex gap-1 transition rounded-full lg:hover:bg-slate-800 px-2 py-1"
            :class="[isExactActive ? 'lg:bg-slate-800 lg:bg-opacity-50' : '']"
        >
            <span class="relative">
                <component
                    :is="icon"
                    class="w-8 h-8 m-auto"
                    :selected="isExactActive"
                />
            </span>
            <span
                class="text-base leading-6 text-center my-auto text-style-button-2"
                :class="{
                    'font-bold text-tint-1': isExactActive,
                    'font-light text-label-3': !isExactActive,
                }"
            >
                <slot />
            </span>
        </span>
    </router-link>
</template>
