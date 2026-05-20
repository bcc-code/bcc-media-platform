<script setup lang="ts">
defineProps<{
  type: PageSection['type']
  size: string
}>()
</script>

<template>
  <!-- FeaturedSection: wide hero banner -->
  <div
    v-if="type === 'FeaturedSection'"
    class="bg-primary-default/15 flex h-16 w-full items-end rounded-lg p-2"
  >
    <div class="flex flex-col gap-1">
      <div class="bg-text-default/20 h-1.5 w-16 rounded-full" />
      <div class="bg-text-default/10 h-1 w-10 rounded-full" />
    </div>
  </div>

  <!-- PosterSection: tall vertical posters in a row -->
  <div
    v-else-if="type === 'PosterSection'"
    class="flex h-16 w-full items-end gap-1.5 overflow-hidden"
  >
    <div
      v-for="i in 5"
      :key="i"
      class="bg-surface-indent shrink-0 rounded-md"
      :class="size === 'small' ? 'h-12 w-8' : 'h-14 w-9'"
    />
  </div>

  <!-- DefaultSection: horizontal carousel of landscape thumbnails -->
  <div
    v-else-if="type === 'DefaultSection'"
    class="flex h-16 w-full items-end gap-1.5 overflow-hidden"
  >
    <div
      v-for="i in 5"
      :key="i"
      class="bg-surface-indent shrink-0 rounded-md"
      :class="size === 'small' ? 'h-8 w-12' : 'h-10 w-16'"
    />
  </div>

  <!-- CardSection: wider cards -->
  <div
    v-else-if="type === 'CardSection'"
    class="flex h-16 w-full items-end gap-1.5 overflow-hidden"
  >
    <div
      v-for="i in 4"
      :key="i"
      class="bg-surface-indent shrink-0 rounded-md"
      :class="size === 'large' ? 'h-12 w-14' : 'h-10 w-10'"
    />
  </div>

  <!-- DefaultGridSection: 2-column grid -->
  <div
    v-else-if="type === 'DefaultGridSection'"
    class="grid h-16 w-full grid-cols-4 items-end gap-1.5 overflow-hidden"
  >
    <div v-for="i in 8" :key="i" class="bg-surface-indent h-7 rounded-md" />
  </div>

  <!-- IconGridSection: icon circles in a grid -->
  <div
    v-else-if="type === 'IconGridSection'"
    class="grid h-16 w-full grid-cols-4 items-end gap-2 overflow-hidden"
  >
    <div v-for="i in 8" :key="i" class="flex flex-col items-center gap-0.5">
      <div class="bg-surface-indent size-5 rounded-full" />
      <div class="bg-surface-indent h-1 w-4 rounded-full" />
    </div>
  </div>
</template>
