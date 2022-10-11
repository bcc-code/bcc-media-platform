<template>
    <section>
        <SectionTitle v-if="item.title">{{item.title}}</SectionTitle>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"
import SectionTitle from "./SectionTitle.vue";

defineProps<{
    item: Section & { __typename: "PosterSection" }
}>()
</script>
