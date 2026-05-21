<script setup lang="ts">
import { Tooltip } from '@ark-ui/vue'
import type { Placement } from '~/types/design'

interface Props {
  content?: string
  placement?: Placement
  gap?: number
  openDelay?: number
  closeDelay?: number
  disabled?: boolean
  interactive?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  content: undefined,
  placement: 'top',
  gap: 8,
  openDelay: 400,
  closeDelay: 150,
  disabled: false,
  interactive: false
})

const positioning = computed(() => ({
  placement: props.placement,
  gap: props.gap
}))
</script>

<template>
  <Tooltip.Root
    :positioning="positioning"
    :open-delay="openDelay"
    :close-delay="closeDelay"
    :disabled="disabled"
    :interactive="interactive"
  >
    <Tooltip.Trigger as-child>
      <slot />
    </Tooltip.Trigger>

    <Teleport to="#teleports">
      <Tooltip.Positioner>
        <Tooltip.Content
          class="gradient-border bg-surface-raise text-caption-1 text-text-default shadow-floating ease-out-expo max-w-xs origin-[--transform-origin] rounded-lg px-2.5 py-1.5 whitespace-normal transition-[opacity,transform] duration-200 data-[state=closed]:scale-95 data-[state=closed]:opacity-0 data-[state=open]:scale-100 data-[state=open]:opacity-100"
        >
          <slot name="content">{{ content }}</slot>
        </Tooltip.Content>
      </Tooltip.Positioner>
    </Teleport>
  </Tooltip.Root>
</template>
