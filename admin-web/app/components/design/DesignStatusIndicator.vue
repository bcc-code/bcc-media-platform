<script setup lang="ts">
import { cva, type VariantProps } from 'cva'

const pill = cva({
  base: 'inline-flex items-center rounded-full ring-1 ring-inset',
  variants: {
    variant: {
      success:
        'bg-semantic-success/10 text-semantic-success ring-semantic-success/20',
      warning:
        'bg-semantic-warning/10 text-semantic-warning ring-semantic-warning/20',
      info: 'bg-semantic-info/10 text-semantic-info ring-semantic-info/20',
      error:
        'bg-semantic-error/10 text-semantic-error ring-semantic-error/20',
      neutral: 'bg-text-hint/10 text-text-muted ring-text-hint/20'
    },
    size: {
      sm: 'text-caption-1 gap-1.5 py-0.5 pl-2 pr-2.5',
      md: 'text-body-3 gap-2 py-1.5 pl-2.5 pr-3.5'
    }
  }
})

const dot = cva({
  base: 'inline-flex shrink-0 rounded-full',
  variants: {
    variant: {
      success: 'bg-semantic-success',
      warning: 'bg-semantic-warning',
      info: 'bg-semantic-info',
      error: 'bg-semantic-error',
      neutral: 'bg-text-hint'
    },
    size: {
      sm: 'size-1.5',
      md: 'size-2'
    }
  }
})

type Variant = NonNullable<VariantProps<typeof pill>['variant']>
type Size = NonNullable<VariantProps<typeof pill>['size']>

interface Props {
  label?: string
  variant?: Variant
  size?: Size
}

withDefaults(defineProps<Props>(), {
  variant: 'neutral',
  size: 'md',
  label: undefined
})
</script>

<template>
  <span :class="pill({ variant, size })">
    <span aria-hidden="true" :class="dot({ variant, size })" />
    <slot>
      {{ label }}
    </slot>
  </span>
</template>
