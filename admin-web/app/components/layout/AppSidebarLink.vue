<script setup lang="ts">
const props = defineProps<{
  to: string
  icon: string
  label: string
  collapsed?: boolean
  demo?: boolean
}>()

const route = useRoute()

const active = computed(() => {
  if (props.to === '/') return route.path === '/'
  return route.path === props.to || route.path.startsWith(props.to + '/')
})
</script>

<template>
  <DesignTooltip
    :content="demo ? `${label} (demo)` : label"
    placement="right"
    :disabled="!collapsed"
  >
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
      <DesignBadge v-if="demo && !collapsed" variant="warning" label="Demo" />
      <span
        v-if="demo && collapsed"
        class="bg-semantic-warning ring-surface-indent absolute top-1 right-1 size-2 rounded-full ring-2"
        aria-hidden="true"
      />
    </NuxtLink>
  </DesignTooltip>
</template>
