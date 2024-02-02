<script lang="ts" setup>
const openLive = () => {
    window.location.href = "https://live.bcc-connect.org"
}
</script>
<template>
    <section
        class="font-medium mx-auto px-2 lg:px-20 max-w-screen-lg py-8 flex"
    >
        <div class="max-w-md mx-auto flex flex-col gap-4">
            <img
                src="/tvos_icon_large.png"
                @click="openLive"
                class="rounded-lg max-w-md mx-auto cursor-pointer hover:-translate-y-0.5 transition duration-50"
            />
            <h3 class="text-lg font-bold">
                {{ $t("live.title") }}
            </h3>
            <p>{{ $t("live.description") }}</p>
            <button
                @click="openLive"
                class="p-4 bg-primary text-xl hover:bg-primary-hover rounded-lg border border-gray transition duration-75 hover:-translate-y-0.5"
            >
                {{ $t("buttons.open") }}
            </button>
        </div>
    </section>
</template>
