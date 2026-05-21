<script setup lang="ts">
defineProps<{
  page: Page
}>()
</script>

<template>
  <tr
    class="border-border-1 hover:bg-surface-indent cursor-pointer border-t"
    @click="navigateTo(`/pages/${page.id}`)"
  >
    <td class="text-title-3 text-text-default px-4 py-3">
      {{ page.title }}
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 font-mono">
      {{ page.code }}
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 tabular-nums">
      {{ page.sections.length }}
    </td>
  </tr>
</template>
