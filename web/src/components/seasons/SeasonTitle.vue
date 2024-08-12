<template>
    <div>
        <p class="text-sm text-primary w-full line-clamp-1">
            {{ season.show.title }}
        </p>
        <p class="text-sm md:text-md lg:text-lg line-clamp-2">
            {{ season.title }}
        </p>
    </div>
</template>
<script lang="ts" setup>
import { Season } from "@/graph/generated"

defineProps<{
    season: Season
}>()
</script>
