<template>
    <div class="flex p-5">
        <div class="mx-auto mt-10 text-center">
            <h1 class="text-2xl font-bold text-red mb-2">{{ title ?? $t("notFound.title")}}</h1>
            <p class="max-w-sm text-lg mb-2">{{$t("notFound.description")}}</p>
            <router-link :to="{name: 'front-page'}" class="text-gray m-2 hover:underline hover:text-white transition hover:bg-slate-400 bg-primary-light p-2 px-3 rounded-full" href="/">{{$t("notFound.returnHome")}}</router-link>
        </div>
    </div>
</template>
<script lang="ts" setup>
defineProps<{
    title?: string
}>()
</script>