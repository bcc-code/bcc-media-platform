<template>
    <div
        @click="handleClick"
        :class="
            'inline-flex space-x-4 items-center justify-start w-full min-h-[4rem] py-2.5 pl-4 bg-separator-on-light bg-opacity-10 rounded-xl border-2 relative ' +
            conditionalClass
        "
    >
        <p
            class="w-5 text-2xl font-extrabold leading-7 text-center text-label-3"
        >
            {{ letter }}
        </p>
        <p class="flex-1 text-label-1 text-style-title-3">{{ text }}</p>

        <div class="flex items-center justify-center p-1.5 pr-4">
            <svg
                v-if="props.selected && props.correct === false"
                width="14"
                height="14"
                viewBox="0 0 14 14"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path d="M13 1L1 13" stroke="#E63C62" stroke-width="2" />
                <path d="M1 1L13 13" stroke="#E63C62" stroke-width="2" />
            </svg>
            <svg
                v-else-if="props.selected && props.correct === true"
                width="15"
                height="12"
                viewBox="0 0 15 12"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    d="M13.7887 1.3033L5.30337 9.78858L1.00007 5.48528"
                    stroke="#71D2A4"
                    stroke-width="2"
                />
            </svg>

            <svg
                v-else-if="props.selected && props.correct === undefined"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <circle cx="12" cy="12" r="12" fill="#6EB0E6" />
                <path
                    d="M18.5387 8.0533L10.0534 16.5386L5.75007 12.2353"
                    stroke="white"
                    stroke-width="2"
                />
            </svg>

            <div class="w-4" v-else>&nbsp;</div>
        </div>
        <div
            class="absolute top-50 left-0 pr-4 pointer-events-none z-20"
            v-if="!competitionMode"
        >
            <LottieAnimation
                ref="confetti"
                :loop="false"
                :auto-play="false"
                width="100%"
                :speed="1"
                @on-complete="() => confetti.stop()"
                :animation-data="confettiAnimation"
            ></LottieAnimation>
        </div>
    </div>
</template>

<script setup lang="ts">
import { webViewMain } from "@/services/webviews/mainHandler"
import { computed, ref, VNodeRef, VueElement } from "vue"
import { Vue3Lottie as LottieAnimation } from "vue3-lottie"
import confettiAnimation from "./confetti.json"

const props = defineProps<{
    letter: String
    text: String
    selected: Boolean
    correct: Boolean | null | undefined
    competitionMode: Boolean
    locked: Boolean
}>()

const confetti = ref()
const shaking = ref(false)
const scaleShaking = ref(false)

function shake() {
    shaking.value = true
    setTimeout(() => {
        shaking.value = false
    }, 300)
}
function scaleShake() {
    scaleShaking.value = true
    setTimeout(() => {
        scaleShaking.value = false
    }, 300)
}

const handleClick = () => {
    if (props.correct === true) {
        confetti.value.stop()
        confetti.value.play()
        scaleShake()
        if (webViewMain) {
            webViewMain.hapticFeedback("heavyImpact")
        } else {
            navigator.vibrate(20)
        }
    } else if (props.correct === false || props.locked) {
        shake()
        if (webViewMain) {
            webViewMain.hapticFeedback("mediumImpact")
        } else {
            navigator.vibrate(40)
        }
    } else {
        if (webViewMain) {
            webViewMain.hapticFeedback("lightImpact")
        } else {
            navigator.vibrate(20)
        }
    }
}

const conditionalClass = computed(() => {
    let classString = ""
    if (shaking.value) {
        classString += " shake"
    }
    if (scaleShaking.value) {
        classString += " scaleShake"
    }
    if (props.selected && props.correct === true) {
        classString += " border-tint-3 cursor-default"
    } else if (props.selected && props.correct === false) {
        classString += " border-tint-2 cursor-default"
    } else if (props.selected && props.correct === undefined) {
        classString += " border-tint-1 cursor-default"
    } else {
        classString += " border-transparent cursor-pointer"
    }
    return classString
})
</script>

<style scoped>
.shake {
    animation: shake 300ms ease-in-out both;
    transform: translate3d(0, 0, 0);
}

@keyframes shake {
    30%,
    50%,
    70% {
        transform: translate3d(-2px, 0, 0);
    }

    40%,
    60% {
        transform: translate3d(2px, 0, 0);
    }
}

.scaleShake {
    animation: scaleShake 200ms cubic-bezier(0, 0.9, 0.14, 0.96) both;
}

@keyframes scaleShake {
    50% {
        transform: scale(102%);
    }
}
</style>
@/services/webviews/mainHandler
