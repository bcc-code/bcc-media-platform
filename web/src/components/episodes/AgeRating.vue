<template>
    <p v-if="episode.ageRating && (episode.ageRating !== 'A' || showA)">
        <span
            class="border text-sm px-1 border-gray border-opacity-20 bg-slate-800 rounded-md"
            >{{ episode.ageRating }}</span
        >
    </p>
</template>
<script lang="ts" setup>
defineProps<{
    episode: {
        ageRating?: string | null
    }
    showA?: boolean
}>()
</script>
