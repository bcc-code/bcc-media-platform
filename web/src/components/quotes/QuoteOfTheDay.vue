<script setup lang="ts">
import Quote from "./Quote.vue"
import quotesRaw from "../../utils/quotes/all.json"
import { useI18n } from "vue-i18n"
import { useAsyncState } from "@vueuse/core"
import { computed } from "vue"

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
</script>

<template>
    <div v-if="isLoading || !quote"></div>
    <Quote v-else-if="quote" :quote="quoteText" :author="quote.author" />
</template>
