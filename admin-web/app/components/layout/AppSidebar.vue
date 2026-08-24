<script setup lang="ts">
const { currentUser, logout, avatarUrl } = useAuth()
const collapsed = useLocalStorage('sidebar:collapsed', false)

const displayName = computed(() => {
  const u = currentUser.value
  if (!u) return ''
  const name = [u.firstName, u.lastName].filter(Boolean).join(' ')
  return name || u.email
})

function toggle() {
  collapsed.value = !collapsed.value
}

async function handleLogout() {
  await logout()
  await navigateTo('/login')
}

interface NavItem {
  to: string
  icon: string
  label: string
  /** Extra path prefixes this area covers, reached through in-page tabs. */
  match?: string[]
}

// One entry per area, not per collection. Sub-views live in tabs inside the
// area — see docs/admin-web-scope.md.
const navItems: NavItem[] = [
  { to: '/', icon: 'tabler:home', label: 'Hjem' },
  {
    to: '/episodes',
    icon: 'tabler:player-play',
    label: 'Episoder',
    match: ['/shorts', '/assets', '/shows', '/seasons']
  },
  {
    to: '/calendar/entries',
    icon: 'tabler:calendar',
    label: 'Kalender',
    match: ['/calendar']
  },
  {
    to: '/pages',
    icon: 'tabler:file-text',
    label: 'Sider',
    match: ['/collections']
  },
  { to: '/notifications', icon: 'tabler:bell', label: 'Push-varsler' },
  { to: '/operations', icon: 'tabler:settings-bolt', label: 'Drift' }
]
</script>

<template>
  <aside
    class="bg-surface-indent border-border-1 ease-out-expo sticky top-0 flex h-screen flex-col border-r transition-[width] duration-200"
    :class="collapsed ? 'w-16' : 'w-64'"
  >
    <div
      class="border-border-1 flex h-14 shrink-0 items-center border-b"
      :class="collapsed ? 'justify-center px-2' : 'px-4'"
    >
      <NuxtLink
        to="/"
        class="text-title-2 text-text-default flex items-center gap-2"
        :aria-label="collapsed ? 'BCC Media Admin' : undefined"
      >
        <LogoSymbol v-if="collapsed" class="h-6" />
        <LogoFull v-else class="h-6 w-max" />
      </NuxtLink>
    </div>

    <nav class="flex flex-1 flex-col gap-1 overflow-y-auto px-2 py-4">
      <AppSidebarLink
        v-for="item in navItems"
        :key="item.to"
        :to="item.to"
        :icon="item.icon"
        :label="item.label"
        :match="item.match"
        :collapsed="collapsed"
      />
    </nav>

    <div class="p-2">
      <AppSidebarLink
        to="/settings"
        icon="tabler:settings"
        label="Innstillinger"
        :collapsed="collapsed"
      />
    </div>

    <div class="border-border-1 border-t p-2">
      <DesignTooltip
        :content="displayName"
        placement="right"
        :disabled="!collapsed"
      >
        <div
          class="flex items-center gap-3 rounded-xl"
          :class="collapsed ? 'justify-center' : 'pl-3'"
        >
          <DesignAvatar :src="avatarUrl()" :name="displayName || undefined" />
          <div v-if="!collapsed" class="min-w-0 flex-1">
            <p class="text-title-3 text-text-default truncate">
              {{ displayName }}
            </p>
            <p class="text-caption-2 text-text-muted truncate">
              {{ currentUser?.email }}
            </p>
          </div>
          <DesignTooltip v-if="!collapsed" content="Logg ut" placement="top">
            <DesignButton
              variant="tertiary"
              icon="tabler:logout"
              aria-label="Logg ut"
              @click="handleLogout"
            />
          </DesignTooltip>
        </div>
      </DesignTooltip>
    </div>

    <div class="border-border-1 flex items-center justify-end border-t p-2">
      <DesignTooltip
        :content="collapsed ? 'Utvid sidemeny' : 'Skjul sidemeny'"
        :placement="collapsed ? 'right' : 'top'"
      >
        <DesignButton
          variant="tertiary"
          :icon="
            collapsed
              ? 'tabler:layout-sidebar-left-expand'
              : 'tabler:layout-sidebar-left-collapse'
          "
          :aria-label="collapsed ? 'Utvid sidemeny' : 'Skjul sidemeny'"
          @click="toggle"
        />
      </DesignTooltip>
    </div>
  </aside>
</template>
