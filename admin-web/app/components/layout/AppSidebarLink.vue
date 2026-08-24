<script setup lang="ts">
const props = defineProps<{
  to: string
  icon: string
  label: string
  collapsed?: boolean
  /** Extra path prefixes that keep this area highlighted. */
  match?: string[]
}>()

const route = useRoute()

const active = computed(() => {
  const paths = [props.to, ...(props.match ?? [])]
  return paths.some((path) => {
    if (path === '/') return route.path === '/'
    return route.path === path || route.path.startsWith(`${path}/`)
  })
})
</script>

<template>
  <DesignTooltip :content="label" placement="right" :disabled="!collapsed">
    <NuxtLink
      :to="to"
      :aria-current="active ? 'page' : undefined"
      :aria-label="collapsed ? label : undefined"
      class="text-title-2 relative flex items-center rounded-xl"
      :class="[
        active
          ? 'bg-surface-default text-text-default'
          : 'text-text-muted hover:bg-surface-default hover:text-text-default',
        collapsed ? 'size-11 justify-center' : 'gap-3 px-4 py-2.5'
      ]"
    >
      <Icon :name="icon" class="size-5 shrink-0" />
      <span v-if="!collapsed" class="flex-1 truncate">{{ label }}</span>
    </NuxtLink>
  </DesignTooltip>
</template>
