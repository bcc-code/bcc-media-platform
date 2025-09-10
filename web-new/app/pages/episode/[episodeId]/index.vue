<script setup lang="ts">
const route = useRoute("episode-episodeId");

const { data, status } = useAsyncGql({
  operation: "getEpisode",
  variables: {
    episodeId: route.params.episodeId,
  },
});
</script>

<template>
  <div
    v-if="status === 'success'"
    class="max-w-screen-lg mx-auto w-full px-2 md:px-20"
  >
    <EpisodePlayer />
    <div class="p-6 bg-primary-light">
      <h1 class="text-style-title-2 lg:text-style-headline-2 text-label-1">
        {{ data.episode.title }}
      </h1>
      <div class="flex gap-2 items-center my-2">
        <span
          class="border rounded-full leading-none px-2 py-0.5 text-xs text-label-4"
        >
          {{ data.episode.ageRating }}
        </span>
        <NuxtLink
          v-if="data.episode.season?.show"
          :to="{
            name: 'show-showId',
            params: { showId: data.episode.season.show.id },
          }"
          class="text-primary hover:underline"
        >
          {{ data.episode.season?.show.title }}
        </NuxtLink>
      </div>
      <p class="text-label-3">{{ data.episode.description }}</p>
    </div>
  </div>
</template>
