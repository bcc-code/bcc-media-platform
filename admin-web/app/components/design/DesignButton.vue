<script setup lang="ts">
import { cva } from 'cva'

interface Props {
  label?: string
  variant?: 'primary' | 'secondary' | 'tertiary'
  intent?: 'neutral' | 'danger'
  size?: 'small' | 'medium' | 'large'
  disabled?: boolean
  loading?: boolean
  icon?: string
}

withDefaults(defineProps<Props>(), {
  variant: 'primary',
  intent: 'neutral',
  size: 'medium',
  icon: undefined,
  label: undefined
})

const classes = cva({
  base: [
    'inline-flex items-center justify-center',
    'select-none cursor-pointer',
    'transition-transform duration-200 ease-out-expo',
    'active:scale-95',
    'disabled:opacity-50 disabled:pointer-events-none disabled:cursor-not-allowed'
  ],
  variants: {
    variant: {
      primary: ['gradient-border-dark'],
      secondary: [],
      tertiary: []
    },
    intent: {
      neutral: [],
      danger: []
    },
    size: {
      small: 'rounded-2xl px-3 py-1.5 text-title-3 gap-1',
      medium: 'rounded-3xl px-4 py-2.5 text-title-2 gap-2',
      large: 'rounded-4xl px-5 py-3.5 text-title-2 gap-2'
    }
  },
  compoundVariants: [
    {
      variant: 'primary',
      intent: 'neutral',
      class: 'bg-primary-default text-on-primary'
    },
    {
      variant: 'primary',
      intent: 'danger',
      class: 'bg-semantic-error text-on-error'
    },
    {
      variant: 'secondary',
      intent: 'neutral',
      class: 'bg-surface-indent text-text-default'
    },
    {
      variant: 'secondary',
      intent: 'danger',
      class: 'bg-semantic-error/10 text-semantic-error'
    },
    {
      variant: 'tertiary',
      intent: 'neutral',
      class: 'bg-transparent text-text-default hover:bg-surface-indent'
    },
    {
      variant: 'tertiary',
      intent: 'danger',
      class: 'bg-transparent text-semantic-error hover:bg-semantic-error/10'
    }
  ]
})
</script>

<template>
  <button
    type="button"
    :class="classes({ variant, intent, size })"
    :disabled="disabled || loading"
  >
    <Icon v-if="icon" :name="icon" />
    <slot>
      {{ label }}
    </slot>
  </button>
</template>
