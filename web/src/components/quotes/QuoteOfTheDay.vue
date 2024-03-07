<script setup lang="ts">
import Quote from "./Quote.vue"
import quotesRaw from "../../utils/quotes/all.json"
import { useI18n } from "vue-i18n"
import { useAsyncState } from "@vueuse/core"
import { computed, ref, watch, watchEffect } from "vue"
import VButton from "../VButton.vue"
import Check from "../icons/Check.vue"

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
}
const hasReadToday = computed(() => readDaysArray.value.includes(todayString))

const share = () => {
    if (navigator.share) {
        navigator.share({
            title: "Quote of the day",
            text: `«${quoteText.value}» - ${quote.author}`,
            url: window.location.href,
        })
    }
}
</script>

<template>
    <div
        class="flex flex-col items-start justify-start w-full py-4 bg-background-2 rounded-2xl hide-scrollbar"
        style="max-height: 100%; overflow-y: auto"
        @click="setRead(true)"
    >
        <div v-if="isLoading || !quote"></div>
        <Quote
            v-else-if="quote"
            :quote="quoteText"
            :author="quote.author"
            class="mx-5"
        />
        <div class="flex gap-2 mx-5 mt-4">
            <VButton
                size="thin"
                :color="hasReadToday ? 'default' : 'secondary'"
                class="bg-background-1 rounded-full"
                @click.stop="setRead(!hasReadToday)"
                :aria-label="
                    hasReadToday
                        ? $t('quotes.markAsUnread')
                        : $t('quotes.markAsRead')
                "
            >
                <Check />
            </VButton>
            <VButton
                color="secondary"
                size="thin"
                class="flex items-center"
                @click="share"
            >
                <svg
                    class="mr-1 h-6 w-6"
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
        </div>
    </div>
</template>
