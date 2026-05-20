<script setup lang="ts">
import { Dialog } from '@ark-ui/vue'

interface Props {
  title?: string
  description?: string
}

withDefaults(defineProps<Props>(), {
  title: undefined,
  description: undefined
})

const open = defineModel<boolean>('open', { default: false })

const initialFocusTarget = ref<HTMLElement | null>(null)

const setInitialFocus = (el: unknown) => {
  if (el == null) {
    initialFocusTarget.value = null
    return
  }
  if (el instanceof HTMLElement) {
    initialFocusTarget.value = el
    return
  }
  const $el = (el as { $el?: unknown }).$el
  if ($el instanceof HTMLElement) {
    initialFocusTarget.value = $el
  }
}

const initialFocusEl = () => initialFocusTarget.value

watch(open, async (isOpen) => {
  if (!isOpen) return
  await nextTick()
  requestAnimationFrame(() => {
    initialFocusTarget.value?.focus()
  })
})
</script>

<template>
  <Dialog.Root
    v-model:open="open"
    lazy-mount
    unmount-on-exit
    :initial-focus-el="initialFocusEl"
  >
    <slot name="trigger" />

    <Teleport to="#teleports">
      <Dialog.Backdrop
        class="fixed inset-0 z-40 bg-black/40 transition-opacity duration-200 data-[state=closed]:opacity-0 data-[state=open]:opacity-100"
      />
      <Dialog.Positioner
        class="fixed inset-0 z-50 flex items-center justify-center p-4"
      >
        <Dialog.Content
          class="gradient-border bg-surface-raise shadow-floating ease-out-expo w-full max-w-lg origin-center rounded-2xl p-6 transition-[opacity,transform] duration-200 data-[state=closed]:scale-95 data-[state=closed]:opacity-0 data-[state=open]:scale-100 data-[state=open]:opacity-100"
        >
          <div v-if="title || description" class="mb-5">
            <Dialog.Title v-if="title" class="text-heading-3 text-text-default">
              {{ title }}
            </Dialog.Title>
            <Dialog.Description
              v-if="description"
              class="text-body-3 text-text-muted mt-1"
            >
              {{ description }}
            </Dialog.Description>
          </div>

          <slot :initial-focus="setInitialFocus" />

          <Dialog.CloseTrigger
            class="text-text-hint hover:text-text-default absolute top-4 right-4 cursor-pointer rounded-lg p-1"
          >
            <Icon name="tabler:x" class="size-5" />
          </Dialog.CloseTrigger>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
  </Dialog.Root>
</template>
