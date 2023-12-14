<template>
    <p v-if="episode.ageRating && (episode.ageRating !== 'A' || showA)">
        <span
            class="border border-[#CCDDFF19] rounded-xl bg-background-2 text-white px-1 text-style-caption-2 lg:text-style-caption-1 pb-[1px]"
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
