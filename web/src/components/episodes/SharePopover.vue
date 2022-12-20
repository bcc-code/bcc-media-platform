<template>
    <img
        class="hover:scale-110 transition mx-auto my-auto"
        v-if="canShare"
        src="/icons/share.svg"
        @click="share()"
    />
    <Popover class="relative" v-else>
        <PopoverButton class="hover:scale-110 transition"
            ><img class="lg:h-8 lg:w-8" src="/icons/share.svg"
        /></PopoverButton>
        <transition type="slide-fade">
            <PopoverPanel
                class="absolute z-10 right-0 bg-slate-700 p-4 shadow-lg rounded-md flex flex-col gap-2"
            >
                <h1 class="text-xl">{{ $t("share.title") }}</h1>
                <div class="bg-slate-800 rounded-md p-2 cursor-pointer hover:scale-[1.01] transition flex" @click="copy()">
                <span ref="locationSpan" class="my-auto">{{ l }}</span
                    ><ClipboardIcon class="h-6 opacity-80 ml-2"></ClipboardIcon>
                </div>
                <p class="text-green-500 transition pointer-events-none" :class="{'opacity-0': !copied}">{{ $t("share.copied") }}</p> 
            </PopoverPanel>
        </transition>
    </Popover>
</template>
<script lang="ts" setup>
import { Popover, PopoverButton, PopoverPanel } from "@headlessui/vue"
import { ClipboardIcon } from "@heroicons/vue/24/outline";
import { computed, ref } from "vue"

const props = defineProps<{
    episode: {
        title: string
    }
}>()

const l = computed(() => {
    return location.href
})

const locationSpan = ref(null as HTMLSpanElement | null)

const canShare = computed(() => {
    return typeof navigator.canShare !== "undefined"
})

const share = () => {
    if (!locationSpan.value) {
        return
    }
    const data = {
        title: props.episode.title,
        url: locationSpan.value.innerText,
    }
    if (typeof navigator.canShare !== "undefined" && navigator.canShare(data)) {
        navigator.share(data)
    }
}

const copied = ref(false)

const copy = () => {
    if (!locationSpan.value) {
        return
    }
    navigator.clipboard.writeText(locationSpan.value.innerText)
    copied.value = true

    setTimeout(() => copied.value = false, 5000)
}
</script>
