<script setup lang="ts">
import router from "@/router"
import { webViewMain } from "@/services/webviews/mainHandler"
import { ref, watch } from "vue"
const openFeedback = () => {
    if (webViewMain) {
        webViewMain.navigate("/r/quotes-feedback")
        return
    }
    // open <host>/r/quotes-feedback in new tab
    window.open("/r/quotes-feedback", "_blank")
}

const open = ref(false)
watch(open, (value) => {
    if (value) {
        setTimeout(() => {
            open.value = false
        }, 4000)
    }
})
</script>
<template>
    <button
        class="absolute bottom-3 h-5 flex items-center justify-center p-1 border rounded-full bg-separator-on-light border-separator-on-light right-3 transition-all duration-700 ease-out-expo overflow-hidden"
        :class="{
            'w-5': !open,
            'w-24 bg-tint-1': open,
        }"
        @click="open = true"
    >
        <transition
            enter-active-class="transition duration-1000 ease-out-expo"
            enter-from-class="opacity-0"
            enter-to-class="opacity-100"
            leave-active-class="absolute"
            leave-from-class="opacity-0"
            leave-to-class="opacity-0"
        >
            <svg
                v-if="!open"
                width="31"
                height="29"
                viewBox="0 0 31 29"
                class="text-label-2 w-full h-full"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    class="stroke-current fill-current"
                    d="M15.7005 1.66699L19.8205 10.0137L29.0339 11.3603L22.3672 17.8537L23.9405 27.027L15.7005 22.6937L7.46052 27.027L9.03385 17.8537L2.36719 11.3603L11.5805 10.0137L15.7005 1.66699Z"
                    fill="inherit"
                    stroke="inherit"
                    stroke-width="3.04762"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                />
            </svg>
            <div
                v-else
                class="text-white px-2 h-3 text-style-caption-2 cursor-pointer flex items-center whitespace-nowrap justify-center"
                @click="openFeedback"
            >
                {{ $t("feedback.giveFeedback") }}
            </div>
        </transition>
    </button>
</template>
