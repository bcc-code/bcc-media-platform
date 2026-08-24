<script setup lang="ts">
import { cva } from 'cva'

withDefaults(
  defineProps<{
    to: string
    icon: string
    count: number
    label: string
    tone?: 'warning' | 'neutral'
  }>(),
  { tone: 'neutral' }
)

const iconBox = cva({
  base: 'flex size-9 shrink-0 items-center justify-center rounded-lg',
  variants: {
    tone: {
      warning: 'bg-semantic-warning/15 text-semantic-warning',
      neutral: 'bg-surface-indent text-text-muted'
    }
  }
})
</script>

<template>
  <NuxtLink
    :to="to"
    class="gradient-border bg-surface-raise shadow-floating ease-out-expo flex items-center gap-4 rounded-2xl p-4 transition-transform duration-200 active:scale-[0.99]"
  >
    <span :class="iconBox({ tone })">
      <Icon :name="icon" class="size-5" />
    </span>
    <span class="min-w-0 flex-1">
      <span class="text-heading-3 text-text-default block tabular-nums">
        {{ count }}
      </span>
      <span class="text-body-3 text-text-muted block truncate">
        {{ label }}
      </span>
    </span>
    <Icon name="tabler:chevron-right" class="text-text-hint size-4 shrink-0" />
  </NuxtLink>
</template>
