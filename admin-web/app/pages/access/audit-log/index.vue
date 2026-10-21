<script setup lang="ts">
definePageMeta({ middleware: 'superuser' })

const { t } = useI18n()
const { accessTabs } = useNav()
const { formatGraphQLError } = useGraphQLError()

useHead({ title: () => t('access.auditLog.title') })

const actionFilter = ref<string[]>([''])
const apiKeyFilter = ref<string[]>([''])
const page = ref(0)

const filter = computed(() => ({
  action: actionFilter.value[0] || null,
  apiKeyId: apiKeyFilter.value[0] || null
}))

watch(filter, () => {
  page.value = 0
})

const { entries, total, fetching, error, refetch } = useAuditLog(page, filter)
const { actions } = useAuditLogActions()
const { apiKeys } = useApiKeys()

const actionItems = computed(() => [
  { label: t('access.auditLog.allActions'), value: '' },
  ...actions.value.map((a) => ({ label: a, value: a }))
])

const apiKeyItems = computed(() => [
  { label: t('access.auditLog.allApiKeys'), value: '' },
  ...apiKeys.value.map((k) => ({ label: k.name, value: k.id }))
])

const pageCount = computed(() =>
  Math.max(1, Math.ceil(total.value / auditLogPageSize))
)

const columns = computed(() => [
  t('access.auditLog.columns.time'),
  t('access.auditLog.columns.action'),
  t('access.auditLog.columns.actor'),
  t('access.auditLog.columns.status')
])
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between gap-4">
      <h1 class="sr-only">{{ t('access.auditLog.title') }}</h1>
      <DesignTabs :items="accessTabs" />
    </div>

    <p class="text-body-3 text-text-muted">
      {{ t('access.auditLog.intro') }}
    </p>

    <div class="flex flex-wrap items-center gap-3">
      <DesignSelect v-model="actionFilter" :items="actionItems" />
      <DesignSelect v-model="apiKeyFilter" :items="apiKeyItems" />
    </div>

    <DesignLoadingState v-if="fetching && entries.length === 0" />

    <DesignErrorState
      v-else-if="error"
      :title="formatGraphQLError(error).title"
      :description="formatGraphQLError(error).description"
    >
      <template #action>
        <DesignButton variant="secondary" @click="refetch">
          {{ t('common.retry') }}
        </DesignButton>
      </template>
    </DesignErrorState>

    <template v-else>
      <DesignTable
        :columns="columns"
        :empty="entries.length === 0 ? t('access.auditLog.empty') : undefined"
      >
        <AuditLogRow v-for="entry in entries" :key="entry.id" :entry="entry" />
      </DesignTable>

      <div
        v-if="total > auditLogPageSize"
        class="flex items-center justify-end gap-3"
      >
        <span class="text-body-3 text-text-muted">
          {{
            t('access.auditLog.pageOf', { page: page + 1, pages: pageCount })
          }}
        </span>
        <DesignButton
          variant="secondary"
          size="small"
          icon="tabler:chevron-left"
          :disabled="page === 0"
          :aria-label="t('access.auditLog.previous')"
          @click="page--"
        />
        <DesignButton
          variant="secondary"
          size="small"
          icon="tabler:chevron-right"
          :disabled="page + 1 >= pageCount"
          :aria-label="t('access.auditLog.next')"
          @click="page++"
        />
      </div>
    </template>
  </div>
</template>
