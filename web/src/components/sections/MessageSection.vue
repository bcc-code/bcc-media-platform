<script lang="ts" setup>
import SectionTitle from "./item/SectionTitle.vue"
import { Section } from "./types"
import { mdToHTML } from "@/services/converter"

defineProps<{
    item: Section & { __typename: "MessageSection" }
}>()
</script>
<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex flex-wrap w-full gap-4">
            <div
                v-for="m in item.messages"
                class="rounded-lg border w-full lg:max-w-2xl"
                :style="{
                    'background-color': m.style.background,
                    'border-color': m.style.border,
                    color: m.style.text,
                }"
            >
                <h1 v-if="m.title" class="p-3 pb-2 text-xl font-semibold">
                    {{ m.title }}
                </h1>
                <hr v-if="m.title && m.content" />
                <p class="p-3 pt-2 text-lg" v-html="mdToHTML(m.content)"></p>
            </div>
        </div>
    </section>
</template>
