<template>
    <Popover class="relative" v-if="canShare">
        <PopoverButton class="hover:scale-110 transition focus:ring-0" ><img src="/icons/share.svg" /></PopoverButton>
        <transition type="slide-fade">
            <PopoverPanel class="absolute z-10 right-0 bg-slate-700 p-4 shadow-lg rounded-md flex flex-col gap-2">
                <h1 class="text-xl">{{ $t("episode.share") }}</h1>
                <div class="bg-slate-800 rounded-md p-2"><span ref="locationSpan">{{ l }}</span><span class="rounded bg-slate-900 px-1" @click="copy()">copy</span></div>
            </PopoverPanel>
        </transition>
    </Popover>
</template>
<script lang="ts" setup>
import { Popover, PopoverButton, PopoverPanel } from '@headlessui/vue';
import { computed, ref } from 'vue';

const l = computed(() => {
    return location.href
})

const locationSpan = ref(null as HTMLSpanElement | null)

const canShare = computed(() => {
    return typeof(navigator.canShare) !== "undefined"
})

const copy = () => {
    if (!locationSpan.value) {
        return
    }
    const data = {
        url: locationSpan.value.innerText,
    }
    if (typeof(navigator.canShare) !== "undefined" && navigator.canShare(data)) {
        navigator.share(data)
    }
}
</script>