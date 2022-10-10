<template>
    <section>
        <h1 class="text-lg" v-if="item.title">
            {{ item.title }}
        </h1>
        {{ item.size }}
        <div class="flex gap-2 overflow-y-scroll">
            <div v-for="i in item.items.items" class="w-480">
                <img :src="(i.image ?? '') + '?w=800'" />
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

defineProps<{
    item: Section & { __typename: "FeaturedSection" }
}>()
</script>
