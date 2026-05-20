<script setup lang="ts">
import { cva } from 'cva'

interface Props {
  icon?: string
  variant?: 'success' | 'warning' | 'info' | 'error' | 'neutral'
}

withDefaults(defineProps<Props>(), {
  icon: undefined,
  variant: 'neutral'
})

const classes = cva({
  base: 'flex items-center gap-3 rounded-xl px-4 py-3 text-body-3',
  variants: {
    variant: {
      success: 'bg-semantic-success/15 text-semantic-success',
      warning: 'bg-semantic-warning/15 text-semantic-warning',
      info: 'bg-semantic-info/15 text-semantic-info',
      error: 'bg-semantic-error/15 text-semantic-error',
      neutral: 'bg-surface-indent text-text-muted'
    }
  }
})
</script>

<template>
  <div :class="classes({ variant })">
    <Icon v-if="icon" :name="icon" class="size-5 shrink-0" />
    <slot />
  </div>
</template>
