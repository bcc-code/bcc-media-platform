<script lang="ts" setup>
import { Section } from '../types'

defineProps<{
    item: Section & { __typename: 'PageDetailsSection' }
}>()
</script>

<template>
    <section class="my-8">
        <h2 v-if="item.title" class="text-style-headline-1 mb-2">
            {{ item.title }}
        </h2>
        <p v-if="item.description" class="text-style-body-2 text-label-3">
            {{ item.description }}
        </p>
    </section>
</template>
