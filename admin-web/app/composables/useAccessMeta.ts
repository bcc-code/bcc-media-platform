import type { AccessLevel, AdminResource } from '~/api/graphql'

/**
 * Translated labels for the access model. The resource order and the status
 * mapping are language-independent and stay in `utils/access.ts`; everything
 * a user reads is resolved here so it follows the chosen language.
 */
export function useAccessMeta() {
  const { t } = useI18n()

  const adminResources = computed(() =>
    adminResourceValues.map((value) => ({
      value,
      label: t(`access.resources.${value}.label`),
      description: t(`access.resources.${value}.description`)
    }))
  )

  const levelItems = computed(() => [
    { label: t('access.levels.none'), value: 'none' },
    ...accessLevelValues.map((value) => ({
      label: t(`access.levels.${value}`),
      value
    }))
  ])

  const searchTypeItems = computed(() =>
    searchTypeValues.map((value) => ({
      label: t(`access.searchTypes.${value}`),
      value
    }))
  )

  function resourceLabel(resource: AdminResource) {
    return t(`access.resources.${resource}.label`)
  }

  function levelLabel(level: AccessLevel) {
    return t(`access.levels.${level}`)
  }

  function statusLabel(status: ApiKeyStatus) {
    return t(`access.apiKeys.status.${status}`)
  }

  function permissionSummary(permissions: readonly PermissionLike[]) {
    if (permissions.length === 0) return t('access.permissions.none')
    return permissions
      .map((p) =>
        t('access.permissions.summaryItem', {
          resource: resourceLabel(p.resource),
          level: levelLabel(p.level).toLowerCase()
        })
      )
      .join(', ')
  }

  return {
    adminResources,
    levelItems,
    searchTypeItems,
    resourceLabel,
    levelLabel,
    statusLabel,
    permissionSummary
  }
}
