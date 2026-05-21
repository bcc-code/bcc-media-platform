<script setup lang="ts">
import { useAuth0 } from '@auth0/auth0-vue'

const { user, logout } = useAuth0()
const collapsed = useLocalStorage('sidebar:collapsed', false)

function toggle() {
  collapsed.value = !collapsed.value
}

function handleLogout() {
  logout({ logoutParams: { returnTo: window.location.origin } })
}

const navSections = [
  {
    label: 'Oversikt',
    items: [{ to: '/', icon: 'tabler:home', label: 'Hjem' }]
  },
  {
    label: 'Innhold',
    items: [
      { to: '/episodes', icon: 'tabler:player-play', label: 'Episoder' },
      {
        to: '/seasons',
        icon: 'tabler:calendar-event',
        label: 'Sesonger',
        demo: true
      },
      { to: '/shows', icon: 'tabler:device-tv', label: 'Serier', demo: true }
    ]
  },
  {
    label: 'Applikasjoner',
    items: [
      { to: '/pages', icon: 'tabler:file-text', label: 'Sider', demo: true },
      {
        to: '/notifications',
        icon: 'tabler:bell',
        label: 'Push-varsler',
        demo: true
      }
    ]
  },
  {
    label: 'Kalender',
    items: [
      {
        to: '/calendar/entries',
        icon: 'tabler:calendar',
        label: 'Oppføringer',
        demo: true
      },
      {
        to: '/calendar/events',
        icon: 'tabler:calendar-event',
        label: 'Hendelser',
        demo: true
      }
    ]
  }
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

    <nav class="flex flex-1 flex-col gap-4 overflow-y-auto px-2 py-4">
      <div v-for="(section, index) in navSections" :key="section.label">
        <p
          v-if="!collapsed && section.label"
          class="text-caption-2 text-text-hint px-2 pb-1 uppercase"
        >
          {{ section.label }}
        </p>
        <hr v-if="collapsed && index > 0" class="border-border-1 mb-1" />
        <div class="flex flex-col gap-1">
          <AppSidebarLink
            v-for="item in section.items"
            :key="item.to"
            :to="item.to"
            :icon="item.icon"
            :label="item.label"
            :collapsed="collapsed"
            :demo="item.demo"
          />
        </div>
      </div>
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
        :content="user?.name ?? user?.email ?? ''"
        placement="right"
        :disabled="!collapsed"
      >
        <div
          class="flex items-center gap-3 rounded-xl"
          :class="collapsed ? 'justify-center' : 'pl-3'"
        >
          <DesignAvatar :src="user?.picture" :name="user?.name ?? undefined" />
          <div v-if="!collapsed" class="min-w-0 flex-1">
            <p class="text-title-3 text-text-default truncate">
              {{ user?.name }}
            </p>
            <p class="text-caption-2 text-text-muted truncate">
              {{ user?.email }}
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
