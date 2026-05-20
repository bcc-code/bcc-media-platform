<script setup lang="ts">
import { cva } from 'cva'

interface Props {
  label?: string
  variant?: 'success' | 'warning' | 'info' | 'error' | 'neutral'
}

withDefaults(defineProps<Props>(), {
  variant: 'neutral',
  label: undefined
})

const classes = cva({
  base: 'inline-flex items-center rounded-lg px-2 py-0.75 text-caption-1',
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
  <span :class="classes({ variant })">
    <slot>
      {{ label }}
    </slot>
  </span>
</template>
