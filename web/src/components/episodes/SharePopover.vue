<template>
    <img
        v-if="canShare"
        class="hover:scale-110 transition mx-auto my-auto"
        src="/icons/share.svg"
        @click="share()"
    />
    <Popover v-else class="relative">
        <PopoverButton class="hover:scale-110 transition"
            ><img class="lg:h-8 lg:w-8" src="/icons/share.svg"
        /></PopoverButton>
        <transition type="transition">
            <PopoverPanel
                class="absolute z-10 right-0 bg-slate-700 p-4 shadow-lg rounded-md flex flex-col gap-2"
            >
                <h1 class="text-xl">{{ $t("share.title") }}</h1>
                <div
                    class="bg-slate-800 rounded-md p-2 cursor-pointer hover:scale-[1.01] transition flex"
                    @click="copy()"
                >
                    <span ref="locationSpan" class="my-auto">{{ l }}</span
                    ><ClipboardIcon class="h-6 opacity-80 ml-2"></ClipboardIcon>
                </div>
                <p
                    class="transition pointer-events-none flex gap-1"
                    :class="{
                        'opacity-0':
                            episode.shareRestriction === 'public' && !copied,
                        'text-green-500': copied,
                    }"
                >
                    <span class="grow-0 my-auto">
                        <InformationCircleIcon
                            v-if="
                                episode.shareRestriction !== 'public' && !copied
                            "
                            class="h-6 w-6 stroke-red-500"
                        ></InformationCircleIcon
                        ><ClipboardIcon
                            v-else
                            class="h-6 w-6 stroke-green-500"
                        ></ClipboardIcon>
                    </span>
                    <span class="grow-0 text-sm my-auto">
                        {{ $t(copied ? "share.copied" : "share.membersOnly") }}
                    </span>
                </p>
            </PopoverPanel>
        </transition>
    </Popover>
</template>
<script lang="ts" setup>
import { Popover, PopoverButton, PopoverPanel } from "@headlessui/vue"
import { ClipboardIcon, InformationCircleIcon } from "@heroicons/vue/24/outline"
import { computed, ref } from "vue"

const props = defineProps<{
    episode: {
        title: string
        shareRestriction: "public" | "registered" | "members"
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
    const data = {
        title: props.episode.title,
        url: l.value,
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

    setTimeout(() => (copied.value = false), 5000)
}
</script>
