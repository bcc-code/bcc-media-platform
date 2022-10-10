<template>
    <section>
        <h1 class="text-lg" v-if="item.title">
            {{ item.title }}
        </h1>
        {{ item.size }}
        <div class="overflow-x-scroll flex gap-4">
            <div
                v-for="i in item.items.items"
                :style="{
                    'background-image': 'url(' + i.image + '?h=400)',
                }"
                class="bg-cover inline-block aspect-video h-60"
            >
                {{ i.title }}
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

defineProps<{
    item: Section & { __typename: "DefaultSection" }
}>()
</script>
