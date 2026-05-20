<script setup lang="ts">
interface Props {
  icon?: string
  title?: string
  description?: string
}

withDefaults(defineProps<Props>(), {
  icon: 'tabler:inbox',
  title: 'Ingenting her ennå',
  description: undefined
})
</script>

<template>
  <DesignViewState :icon="icon" :title="title" :description="description">
    <template v-if="$slots.action" #action>
      <slot name="action" />
    </template>
  </DesignViewState>
</template>
