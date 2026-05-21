<script setup lang="ts">
interface Props {
  icon?: string
  title?: string
  description?: string
}

withDefaults(defineProps<Props>(), {
  icon: 'tabler:alert-triangle',
  title: 'Noe gikk galt',
  description: undefined
})
</script>

<template>
  <DesignViewState
    :icon="icon"
    :title="title"
    :description="description"
    icon-class="text-semantic-error!"
  >
    <template v-if="$slots.action" #action>
      <slot name="action" />
    </template>
  </DesignViewState>
</template>
