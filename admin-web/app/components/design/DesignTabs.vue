<script setup lang="ts">
defineProps<{
  items: TabItem[]
}>()

const route = useRoute()

function isActive(to: string) {
  return route.path === to || route.path.startsWith(`${to}/`)
}
</script>

<template>
  <nav
    class="bg-surface-indent inline-flex items-center gap-0.5 rounded-xl p-1"
  >
    <NuxtLink
      v-for="item in items"
      :key="item.to"
      :to="item.to"
      :aria-current="isActive(item.to) ? 'page' : undefined"
      class="text-title-3 ease-out-expo inline-flex items-center gap-1.5 rounded-lg px-3 py-1.5 transition-colors duration-150 select-none"
      :class="
        isActive(item.to)
          ? 'gradient-border bg-surface-raise shadow-resting text-text-default'
          : 'text-text-muted hover:text-text-default'
      "
    >
      <Icon v-if="item.icon" :name="item.icon" class="size-4" />
      {{ item.label }}
    </NuxtLink>
  </nav>
</template>
