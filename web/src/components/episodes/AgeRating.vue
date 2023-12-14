<template>
    <p v-if="episode.ageRating && (episode.ageRating !== 'A' || showA)">
        <span
            class="border border-[#CCDDFF19] bg-[#1D2838] px-1 rounded-xl font-medium"
        >
            {{ episode.ageRating }}
        </span>
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
