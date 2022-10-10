<template>
    <section>
        <h1 class="text-lg" v-if="item.title">
            {{ item.title }}
        </h1>
        <div>
            <p></p>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

defineProps<{
    item: Section & { __typename: "GridSection" }
}>()
</script>
