<script setup lang="ts">
import { Toast, Toaster } from '@ark-ui/vue'

const toaster = useToast()

const toastIcons: Record<string, { name: string; color: string }> = {
  info: { name: 'tabler:info-circle', color: 'text-semantic-info' },
  success: { name: 'tabler:check', color: 'text-semantic-success' },
  warning: { name: 'tabler:alert-triangle', color: 'text-semantic-warning' },
  error: { name: 'tabler:x', color: 'text-semantic-error' }
}
</script>

<template>
  <Teleport to="#teleports">
    <Toaster v-slot="toast" :toaster="toaster">
      <Toast.Root
        class="gradient-border bg-surface-raise shadow-floating pointer-events-auto w-80 rounded-xl p-4"
      >
        <div class="flex items-start justify-between gap-3">
          <Icon
            v-if="toast.type && toastIcons[toast.type]"
            :name="toastIcons[toast.type]!.name"
            :class="[toastIcons[toast.type]!.color, 'shrink-0']"
          />
          <div class="flex-1">
            <Toast.Title class="text-title-3 text-text-default">
              {{ toast.title }}
            </Toast.Title>
            <Toast.Description
              v-if="toast.description !== undefined"
              class="text-body-3 text-text-muted mt-0.5"
            >
              {{ toast.description }}
            </Toast.Description>
            <Toast.ActionTrigger v-if="toast.action" as-child>
              <DesignButton variant="secondary" size="small" class="mt-2">
                {{ toast.action.label }}
              </DesignButton>
            </Toast.ActionTrigger>
          </div>
          <Toast.CloseTrigger
            class="text-text-hint hover:text-text-default -m-1 flex grow-0 cursor-pointer rounded-lg p-1"
          >
            <Icon name="tabler:x" />
          </Toast.CloseTrigger>
        </div>
      </Toast.Root>
    </Toaster>
  </Teleport>
</template>

<style scoped>
:deep([data-scope='toast'][data-part='root']) {
  translate: var(--x) var(--y);
  scale: var(--scale);
  z-index: var(--z-index);
  height: var(--height);
  opacity: var(--opacity);
  will-change: translate, opacity, scale;
  transition:
    translate 400ms,
    scale 400ms,
    opacity 400ms,
    height 400ms,
    box-shadow 200ms;
  transition-timing-function: cubic-bezier(0.21, 1.02, 0.73, 1);
}

:deep([data-scope='toast'][data-part='root'][data-state='closed']) {
  transition:
    translate 400ms,
    scale 400ms,
    opacity 200ms;
  transition-timing-function: cubic-bezier(0.06, 0.71, 0.55, 1);
}
</style>
