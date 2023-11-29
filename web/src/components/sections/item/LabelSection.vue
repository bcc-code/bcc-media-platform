<template>
    <section>
        <h1 class="text-lg" v-if="item.title">
            {{ item.title }}
        </h1>
        <div class="flex gap-2">
            <div
                v-for="(i, index) in item.items.items"
                class="bg-slate-800 px-3 py-0.5 border border-1 border-slate-700 rounded-full cursor-pointer"
                @click="$emit('clickItem', index)"
            >
                <p class="text-lg">{{ i.title }}</p>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"

defineProps<{
    position: number
    item: Section & { __typename: "LabelSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()
</script>
