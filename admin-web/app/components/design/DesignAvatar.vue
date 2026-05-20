<script setup lang="ts">
import { Avatar } from '@ark-ui/vue'
import { cva } from 'cva'

interface Props {
  src?: string
  name?: string
  size?: 'small' | 'medium' | 'large'
}

const props = withDefaults(defineProps<Props>(), {
  src: undefined,
  name: undefined,
  size: 'medium'
})

const initials = computed(() => {
  if (!props.name) return '?'
  return props.name
    .split(' ')
    .map((n) => n[0])
    .slice(0, 2)
    .join('')
    .toUpperCase()
})

const classes = cva({
  base: 'relative inline-flex shrink-0 items-center justify-center overflow-hidden rounded-full',
  variants: {
    size: {
      small: 'size-6 text-caption-2',
      medium: 'size-8 text-caption-1',
      large: 'size-10 text-title-3'
    }
  }
})
</script>

<template>
  <Avatar.Root :class="classes({ size })">
    <Avatar.Fallback
      class="bg-primary-default text-on-primary flex size-full items-center justify-center font-semibold"
    >
      {{ initials }}
    </Avatar.Fallback>
    <Avatar.Image
      v-if="src"
      :src="src"
      :alt="name ?? ''"
      class="size-full object-cover"
    />
  </Avatar.Root>
</template>
