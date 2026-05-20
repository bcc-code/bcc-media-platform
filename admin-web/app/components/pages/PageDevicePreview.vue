<script setup lang="ts">
defineProps<{
  sections: PageSection[]
}>()
</script>

<template>
  <DevicePreview>
    <div
      v-for="section in sections"
      :key="section.id"
      class="flex shrink-0 flex-col gap-1.5"
    >
      <!-- Section title -->
      <span
        v-if="section.title"
        class="truncate text-xs font-semibold text-neutral-900 dark:text-white"
      >
        {{ section.title }}
      </span>

      <!-- FeaturedSection: hero banner -->
      <div
        v-if="section.type === 'FeaturedSection'"
        class="flex items-end rounded-lg bg-purple-400/30 p-3 dark:bg-purple-400/20"
        :class="section.size === 'small' ? 'h-20' : 'h-28'"
      >
        <div class="flex flex-col gap-1">
          <div
            class="h-1.5 w-16 rounded-full bg-neutral-900/30 dark:bg-white/25"
          />
          <div
            class="h-1 w-10 rounded-full bg-neutral-900/20 dark:bg-white/15"
          />
        </div>
      </div>

      <!-- PosterSection: tall posters -->
      <div
        v-else-if="section.type === 'PosterSection'"
        class="flex gap-1.5 overflow-hidden"
      >
        <div
          v-for="i in 5"
          :key="i"
          class="shrink-0 rounded-md bg-neutral-900/10 dark:bg-white/8"
          :class="section.size === 'small' ? 'h-14 w-10' : 'h-20 w-13'"
        />
      </div>

      <!-- DefaultSection: landscape thumbnails -->
      <div
        v-else-if="section.type === 'DefaultSection'"
        class="flex gap-1.5 overflow-hidden"
      >
        <div
          v-for="i in 5"
          :key="i"
          class="shrink-0 rounded-md bg-neutral-900/10 dark:bg-white/8"
          :class="section.size === 'small' ? 'h-8 w-14' : 'h-11 w-19'"
        />
      </div>

      <!-- CardSection -->
      <div
        v-else-if="section.type === 'CardSection'"
        class="flex gap-1.5 overflow-hidden"
      >
        <div
          v-for="i in 4"
          :key="i"
          class="shrink-0 rounded-md bg-neutral-900/10 dark:bg-white/8"
          :class="section.size === 'large' ? 'h-14 w-16' : 'h-11 w-11'"
        />
      </div>

      <!-- DefaultGridSection -->
      <div
        v-else-if="section.type === 'DefaultGridSection'"
        class="grid grid-cols-4 gap-1.5 overflow-hidden"
      >
        <div
          v-for="i in 8"
          :key="i"
          class="h-7 rounded-md bg-neutral-900/10 dark:bg-white/8"
        />
      </div>

      <!-- IconGridSection -->
      <div
        v-else-if="section.type === 'IconGridSection'"
        class="grid grid-cols-4 gap-x-1.5 gap-y-2 overflow-hidden"
      >
        <div v-for="i in 8" :key="i" class="flex flex-col items-center gap-0.5">
          <div class="size-6 rounded-full bg-neutral-900/10 dark:bg-white/8" />
          <div class="h-1 w-4 rounded-full bg-neutral-900/10 dark:bg-white/8" />
        </div>
      </div>
    </div>
  </DevicePreview>
</template>
