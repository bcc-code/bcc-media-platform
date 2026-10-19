<script setup lang="ts">
definePageMeta({ middleware: 'superuser' })
useHead({ title: 'API-nøkler' })

const { apiKeys, fetching, error, refetch } = useApiKeys()

const showRevoked = ref(false)

const visibleKeys = computed(() =>
  apiKeys.value.filter((k) => showRevoked.value || !k.revokedAt)
)
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between gap-4">
      <h1 class="sr-only">API-nøkler</h1>
      <DesignTabs :items="accessTabs" />
      <NuxtLink to="/access/api-keys/new">
        <DesignButton icon="tabler:plus">Ny nøkkel</DesignButton>
      </NuxtLink>
    </div>

    <div class="flex items-center gap-3">
      <DesignSwitch v-model="showRevoked" label="Vis tilbakekalte" />
    </div>

    <DesignLoadingState v-if="fetching && apiKeys.length === 0" />

    <DesignErrorState
      v-else-if="error"
      :title="formatGraphQLError(error).title"
      :description="formatGraphQLError(error).description"
    >
      <template #action>
        <DesignButton variant="secondary" @click="refetch">
          Prøv igjen
        </DesignButton>
      </template>
    </DesignErrorState>

    <DesignTable
      v-else
      :columns="['Navn', 'Nøkkel', 'Status', 'Utløper', 'Opprettet']"
      :empty="visibleKeys.length === 0 ? 'Ingen API-nøkler.' : undefined"
    >
      <NuxtLink
        v-for="apiKey in visibleKeys"
        :key="apiKey.id"
        :to="`/access/api-keys/${apiKey.id}`"
        custom
      >
        <template #default="{ navigate }">
          <ApiKeyRow :api-key="apiKey" @click="navigate" />
        </template>
      </NuxtLink>
    </DesignTable>
  </div>
</template>
