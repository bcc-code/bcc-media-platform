<script setup lang="ts">
const state = useConfirmState()

const open = computed({
  get: () => state.value.open,
  set: (value) => {
    if (!value) {
      state.value.resolve?.(false)
      state.value = { ...state.value, open: false, resolve: null }
    }
  }
})

function handleConfirm() {
  state.value.resolve?.(true)
  state.value = { ...state.value, open: false, resolve: null }
}

function handleCancel() {
  state.value.resolve?.(false)
  state.value = { ...state.value, open: false, resolve: null }
}
</script>

<template>
  <DesignDialog
    v-model:open="open"
    :title="state.options?.title"
    :description="state.options?.description"
  >
    <template #default="{ initialFocus }">
      <div class="mt-5 flex justify-end gap-2">
        <DesignButton
          :ref="initialFocus"
          variant="tertiary"
          @click="handleCancel"
        >
          {{ state.options?.cancelLabel ?? 'Avbryt' }}
        </DesignButton>
        <DesignButton
          variant="primary"
          :intent="state.options?.intent ?? 'neutral'"
          @click="handleConfirm"
        >
          {{ state.options?.confirmLabel ?? 'OK' }}
        </DesignButton>
      </div>
    </template>
  </DesignDialog>
</template>
