<script setup lang="ts">
definePageMeta({ middleware: 'superuser' })
useHead({ title: 'Roller' })

const { roles, fetching, error } = useRoles()
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between gap-4">
      <h1 class="sr-only">Roller</h1>
      <DesignTabs :items="accessTabs" />
    </div>

    <p class="text-body-3 text-text-muted">
      Roller opprettes i Directus. Her styrer du hva hver rolle får gjøre i
      admin. Brukere med administratortilgang i Directus har alltid full
      tilgang.
    </p>

    <DesignLoadingState v-if="fetching && roles.length === 0" />

    <DesignErrorState
      v-else-if="error"
      :title="formatGraphQLError(error).title"
      :description="formatGraphQLError(error).description"
    />

    <DesignTable
      v-else
      :columns="['Rolle', 'Tilganger']"
      :empty="roles.length === 0 ? 'Ingen roller funnet.' : undefined"
    >
      <NuxtLink
        v-for="role in roles"
        :key="role.id"
        :to="`/access/roles/${role.id}`"
        custom
      >
        <template #default="{ navigate }">
          <RoleRow :role="role" @click="navigate" />
        </template>
      </NuxtLink>
    </DesignTable>
  </div>
</template>
