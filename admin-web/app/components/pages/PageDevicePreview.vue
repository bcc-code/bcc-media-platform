<script setup lang="ts">
defineProps<{
  sections: PageSection[]
}>()

const block = 'shrink-0 rounded-md bg-neutral-900/10 dark:bg-white/8'
</script>

<template>
  <DevicePreview>
    <div
      v-for="section in sections"
      :key="section.id"
      class="flex shrink-0 flex-col gap-1.5"
    >
      <span
        v-if="section.title && section.showTitle"
        class="truncate text-xs font-semibold text-neutral-900 dark:text-white"
      >
        {{ section.title }}
      </span>

      <!-- Hero -->
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

      <!-- Poster carousel -->
      <div
        v-else-if="section.type === 'PosterSection'"
        class="flex gap-1.5 overflow-hidden"
      >
        <div
          v-for="i in 5"
          :key="i"
          :class="[block, section.size === 'small' ? 'h-14 w-10' : 'h-20 w-13']"
        />
      </div>

      <!-- Landscape carousel -->
      <div
        v-else-if="section.type === 'DefaultSection'"
        class="flex gap-1.5 overflow-hidden"
      >
        <div
          v-for="i in 5"
          :key="i"
          :class="[block, section.size === 'small' ? 'h-8 w-14' : 'h-11 w-19']"
        />
      </div>

      <!-- Cards -->
      <div
        v-else-if="section.type === 'CardSection'"
        class="flex gap-1.5 overflow-hidden"
      >
        <div
          v-for="i in 4"
          :key="i"
          :class="[block, section.size === 'large' ? 'h-14 w-16' : 'h-11 w-11']"
        />
      </div>

      <!-- Vertical list -->
      <div
        v-else-if="section.type === 'ListSection'"
        class="flex flex-col gap-1.5"
      >
        <div v-for="i in 3" :key="i" class="flex items-center gap-2">
          <div :class="[block, 'h-8 w-14']" />
          <div class="flex flex-1 flex-col gap-1">
            <div class="h-1.5 w-2/3 rounded-full bg-neutral-900/15 dark:bg-white/10" />
            <div class="h-1 w-1/3 rounded-full bg-neutral-900/10 dark:bg-white/8" />
          </div>
        </div>
      </div>

      <!-- Card list -->
      <div
        v-else-if="section.type === 'CardListSection'"
        class="flex flex-col gap-1.5"
      >
        <div v-for="i in 3" :key="i" :class="[block, 'h-10 w-full']" />
      </div>

      <!-- Icon carousel -->
      <div
        v-else-if="section.type === 'IconSection'"
        class="flex gap-2 overflow-hidden"
      >
        <div v-for="i in 5" :key="i" class="flex flex-col items-center gap-1">
          <div class="size-9 rounded-full bg-neutral-900/10 dark:bg-white/8" />
          <div class="h-1 w-5 rounded-full bg-neutral-900/10 dark:bg-white/8" />
        </div>
      </div>

      <!-- Avatars -->
      <div
        v-else-if="section.type === 'AvatarSection'"
        class="flex gap-2 overflow-hidden"
      >
        <div v-for="i in 5" :key="i" class="flex flex-col items-center gap-1">
          <div class="size-11 rounded-full bg-neutral-900/10 dark:bg-white/8" />
          <div class="h-1 w-6 rounded-full bg-neutral-900/10 dark:bg-white/8" />
        </div>
      </div>

      <!-- Labels -->
      <div
        v-else-if="section.type === 'LabelSection'"
        class="flex gap-1.5 overflow-hidden"
      >
        <div
          v-for="i in 4"
          :key="i"
          class="h-5 w-12 shrink-0 rounded-full bg-neutral-900/10 dark:bg-white/8"
        />
      </div>

      <!-- Landscape grid -->
      <div
        v-else-if="section.type === 'DefaultGridSection'"
        class="grid grid-cols-4 gap-1.5 overflow-hidden"
      >
        <div v-for="i in 8" :key="i" class="h-7 rounded-md bg-neutral-900/10 dark:bg-white/8" />
      </div>

      <!-- Poster grid -->
      <div
        v-else-if="section.type === 'PosterGridSection'"
        class="grid grid-cols-3 gap-1.5 overflow-hidden"
      >
        <div v-for="i in 6" :key="i" class="h-16 rounded-md bg-neutral-900/10 dark:bg-white/8" />
      </div>

      <!-- Icon grid -->
      <div
        v-else-if="section.type === 'IconGridSection'"
        class="grid grid-cols-4 gap-x-1.5 gap-y-2 overflow-hidden"
      >
        <div v-for="i in 8" :key="i" class="flex flex-col items-center gap-0.5">
          <div class="size-6 rounded-full bg-neutral-900/10 dark:bg-white/8" />
          <div class="h-1 w-4 rounded-full bg-neutral-900/10 dark:bg-white/8" />
        </div>
      </div>

      <!-- Message banner -->
      <div
        v-else-if="section.type === 'MessageSection'"
        class="rounded-xl bg-amber-500/15 p-2.5 ring-1 ring-amber-400/30 ring-inset"
      >
        <div class="flex gap-2">
          <div class="mt-0.5 size-3 shrink-0 rounded-full bg-amber-400/60" />
          <div class="flex flex-1 flex-col gap-1">
            <div class="h-1.5 w-2/3 rounded-full bg-amber-300/50" />
            <div class="h-1 w-full rounded-full bg-amber-300/30" />
          </div>
        </div>
      </div>

      <!-- Embedded web page -->
      <div
        v-else-if="section.type === 'WebSection'"
        class="flex h-24 items-center justify-center rounded-lg border border-dashed border-neutral-400/40 dark:border-white/15"
      >
        <span class="text-[10px] text-neutral-500">
          {{ section.embedUrl || 'nettside' }}
        </span>
      </div>

      <!-- Achievements -->
      <div
        v-else-if="section.type === 'AchievementSection'"
        class="flex gap-2 overflow-hidden"
      >
        <div
          v-for="i in 4"
          :key="i"
          class="size-10 shrink-0 rotate-45 rounded-md bg-neutral-900/10 dark:bg-white/8"
        />
      </div>

      <!-- Page details -->
      <div
        v-else-if="section.type === 'PageDetailsSection'"
        class="flex flex-col gap-1.5"
      >
        <div class="h-2.5 w-1/2 rounded-full bg-neutral-900/20 dark:bg-white/15" />
        <div class="h-1.5 w-full rounded-full bg-neutral-900/10 dark:bg-white/8" />
        <div class="h-1.5 w-4/5 rounded-full bg-neutral-900/10 dark:bg-white/8" />
      </div>
    </div>
  </DevicePreview>
</template>
