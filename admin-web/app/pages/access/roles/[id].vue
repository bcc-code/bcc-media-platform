<script setup lang="ts">
import type { PermissionInput } from '~/api/graphql'

definePageMeta({ middleware: 'superuser' })

const route = useRoute('access-roles-id')
const { roles, fetching, setPermissions } = useRoles()
const toaster = useToast()

const role = computed(() => roles.value.find((r) => r.id === route.params.id))

useHead({ title: () => role.value?.name ?? 'Rolle' })

const permissions = ref<PermissionInput[]>([])
const initialPermissions = ref<PermissionInput[]>([])
const loaded = ref(false)

const { allowLeave } = useLeaveGuard(
  () =>
    loaded.value &&
    !samePermissions(permissions.value, initialPermissions.value)
)

watch(
  role,
  (value) => {
    if (!value || loaded.value) return
    permissions.value = toPermissionInputs(value.permissions)
    initialPermissions.value = permissions.value
    loaded.value = true
  },
  { immediate: true }
)

const saving = ref(false)

async function handleSave() {
  saving.value = true
  const { error } = await setPermissions(route.params.id, permissions.value)
  saving.value = false
  if (error) {
    toaster.value.error(formatGraphQLError(error))
    return
  }
  allowLeave()
  toaster.value.success({
    title: 'Tilganger oppdatert',
    description:
      permissions.value.length === 0
        ? 'Brukere med denne rollen kan ikke lenger logge inn i admin.'
        : 'Endringene gjelder umiddelbart.'
  })
  navigateTo('/access/roles')
}
</script>

<template>
  <div v-if="role && loaded" class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/access/roles" label="Tilbake til roller" />
      <h1 class="text-heading-2 text-text-default">{{ role.name }}</h1>
    </div>

    <div class="flex flex-col gap-3">
      <div>
        <h2 class="text-title-1 text-text-default">Tilganger</h2>
        <p class="text-body-3 text-text-muted mt-1">
          En rolle uten tilganger gir ikke innlogging i admin.
        </p>
      </div>
      <PermissionEditor v-model="permissions" />
    </div>

    <div class="border-border-1 flex items-center gap-3 border-t pt-6">
      <DesignButton :loading="saving" @click="handleSave">
        Lagre endringer
      </DesignButton>
      <DesignButton variant="secondary" @click="navigateTo('/access/roles')">
        Avbryt
      </DesignButton>
    </div>
  </div>

  <DesignLoadingState v-else-if="fetching" />

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Rollen ble ikke funnet.
  </div>
</template>
