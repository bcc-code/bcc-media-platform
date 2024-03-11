<script setup lang="ts">
import Quote from "./Quote.vue"
import quotesRaw from "../../utils/quotes/all.json"
import { useI18n } from "vue-i18n"
import { useAsyncState } from "@vueuse/core"
import { computed, onMounted, ref, watch, watchEffect } from "vue"
import VButton from "../VButton.vue"
import Check from "../icons/Check.vue"
import { analytics } from "@/services/analytics"
import QuoteFeedbackButton from "./QuoteFeedbackButton.vue"
import { webViewMain } from "@/services/webviews/mainHandler"

type Quote = (typeof quotesRaw)[keyof typeof quotesRaw]
const quotes = quotesRaw as Record<string, Quote>

type LocalizedModule = {
    default: Record<string, string>
}
const localized = import.meta.glob<LocalizedModule>(
    "../../utils/quotes/localized/*.json"
)

const today = new Date()

let quote = quotes[Math.floor(Math.random() * Object.keys(quotes).length)]
for (const key in quotes) {
    const val = quotes[key]
    //published_at: 07/03/2024 for example, but that's day/month/year
    const publishedAt = new Date(
        val.published_at.split("/").reverse().join("/")
    )
    if (
        publishedAt.getDate() === today.getDate() &&
        publishedAt.getMonth() === today.getMonth() &&
        publishedAt.getFullYear() === today.getFullYear()
    ) {
        quote = val
        break
    }
}

const { locale } = useI18n()

let localizedQuotesPromise =
    localized[`../../utils/quotes/localized/${locale.value}.json`]?.()

const { isLoading, state: localizedQuotes } = useAsyncState(
    localizedQuotesPromise,
    undefined
)

const quoteText = computed(() => {
    return localizedQuotes.value?.default[quote.id] ?? quote.quote
})

const todayString = `${today.getFullYear()}-${today.getMonth()}-${today.getDate()}`
const readDaysArray = ref(localStorage.getItem("read_days")?.split(",") ?? [])
watch(readDaysArray, () => {
    localStorage.setItem("read_days", readDaysArray.value.join(","))
})
const setRead = (val: boolean) => {
    if (!val) {
        readDaysArray.value = readDaysArray.value.filter(
            (day) => day !== todayString
        )
    } else {
        readDaysArray.value = [...readDaysArray.value, todayString]
    }
    analytics.track("interaction", {
        contextElementId: quote.id,
        contextElementType: "Quote",
        interaction: "quote_read",
        meta: {
            quoteId: quote.id,
            pageCode: "qotd",
        },
    })
}
const hasReadToday = computed(() => readDaysArray.value.includes(todayString))
const { t } = useI18n()

const shareSupported =
    (navigator.share && typeof navigator.share === "function") ||
    (webViewMain?.supportedFeatures?.get("share") ?? false)
const share = () => {
    analytics.track("content_shared", {
        elementId: quote.id,
        elementType: "Quote",
        pageCode: "qotd",
    })
    const shareSubject = t("quotes.quoteOfTheDay")
    const shareText = `«${quoteText.value}» - ${quote.author}`
    if (navigator.share && typeof navigator.share === "function") {
        navigator.share({
            title: shareSubject,
            text: shareText,
        })
    } else if (webViewMain?.supportedFeatures?.get("share")) {
        webViewMain.share(shareText, shareSubject)
    } else {
        console.error("Share not supported")
    }
}

onMounted(async () => {
    analytics.page({
        id: "qotd",
        title: "Quote of the day",
        meta: {
            quoteId: quote.id,
        },
    })
})
</script>

<template>
    <div
        class="flex flex-col items-center justify-center w-full bg-background-2 from-tint-2 to-tint-1 rounded-2xl hide-scrollbar h-full"
        style="max-height: 100%; overflow-y: auto"
        @dblclick="setRead(false)"
    >
        <div v-if="isLoading || !quote"></div>
        <Quote
            v-else-if="quote"
            :quote="quoteText"
            :author="quote.author"
            class="px-8 pt-3 py-4"
        />
        <div class="flex gap-2 mx-5 w-full pt-1 items-center justify-center">
            <transition
                enter-active-class="transition duration-150 ease-out"
                enter-from-class="opacity-0"
                enter-to-class="opacity-100"
                leave-active-class="transition duration-150 ease-out"
                leave-from-class="opacity-100"
                leave-to-class="opacity-0"
                mode="out-in"
            >
                <VButton
                    v-if="!hasReadToday"
                    size="thin"
                    class="bg-background-1 rounded-full transition duration-150 ease-out flex items-center"
                    @click.stop="setRead(true)"
                >
                    <Check class="inline-block mr-1" />
                    {{ $t("quotes.markAsRead") }}
                </VButton>
                <VButton
                    color="default"
                    size="thin"
                    class="flex items-center"
                    @click.stop="share"
                    v-else-if="shareSupported"
                >
                    <svg
                        class="h-6 w-6 mr-1"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            fill-rule="evenodd"
                            clip-rule="evenodd"
                            d="M3 13L3 18C3 19.6569 4.34315 21 6 21L18 21C19.6569 21 21 19.6569 21 18L21 13L19 13L19 18C19 18.5523 18.5523 19 18 19L6 19C5.44772 19 5 18.5523 5 18L5 13L3 13Z"
                            fill="currentColor"
                        />
                        <path
                            fill-rule="evenodd"
                            clip-rule="evenodd"
                            d="M16.9246 7.92463L13.407 4.40704L12 3L10.5786 4.42139L7.02515 7.97486L8.43218 9.3819L11 6.81408V15H13V6.84278L15.5033 9.34602L16.9246 7.92463Z"
                            fill="currentColor"
                        />
                    </svg>
                    {{ $t("share.title") }}
                </VButton>
            </transition>
            <QuoteFeedbackButton />
        </div>
    </div>
</template>
