<script setup lang="ts">
import { Menu } from '@ark-ui/vue'

const { brand, brands, current } = useBrand()
const colorMode = useColorMode()

const swatchFor = (b: BrandInfo) =>
  colorMode.value === 'dark' ? b.swatch.dark : b.swatch.light
</script>

<template>
  <Menu.Root :positioning="{ placement: 'top-start', gutter: 4 }">
    <Menu.Trigger
      class="ease-out-expo text-text-default hover:bg-surface-indent inline-flex cursor-pointer items-center justify-center rounded-3xl px-4 py-2.5 transition-transform duration-200 select-none active:scale-95"
      :aria-label="`Brand: ${current.label}`"
    >
      <span
        class="border-border-1 size-5 rounded-full border"
        :style="{ backgroundColor: swatchFor(current) }"
      />
    </Menu.Trigger>

    <Teleport to="#teleports">
      <Menu.Positioner>
        <Menu.Content
          class="gradient-border bg-surface-raise shadow-floating ease-out-expo min-w-44 origin-[--transform-origin] rounded-xl p-1 transition-[opacity,transform] duration-200 data-[state=closed]:scale-95 data-[state=closed]:opacity-0 data-[state=open]:scale-100 data-[state=open]:opacity-100"
        >
          <Menu.Item
            v-for="b in brands"
            :key="b.value"
            :value="b.value"
            class="text-body-3 text-text-default data-highlighted:bg-surface-indent flex cursor-pointer items-center justify-between gap-2 rounded-lg px-3 py-2"
            @click="brand = b.value"
          >
            <span class="flex items-center gap-2">
              <span
                class="border-border-1 size-4 rounded-full border"
                :style="{ backgroundColor: swatchFor(b) }"
              />
              <span>{{ b.label }}</span>
            </span>
            <Icon
              v-if="brand === b.value"
              name="tabler:check"
              class="text-primary-contrast size-4"
            />
          </Menu.Item>
        </Menu.Content>
      </Menu.Positioner>
    </Teleport>
  </Menu.Root>
</template>
