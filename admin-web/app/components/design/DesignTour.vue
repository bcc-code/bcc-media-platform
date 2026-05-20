<script setup lang="ts">
import { Tour, useTour, type TourStepDetails } from '@ark-ui/vue'

interface Props {
  steps: TourStepDetails[]
}

const props = defineProps<Props>()

const tour = useTour({ steps: props.steps })

defineExpose({ start: () => tour.value.start(), tour })
</script>

<template>
  <Tour.Root :tour="tour">
    <Teleport to="body">
      <Tour.Backdrop
        class="ease-out-expo fixed inset-0 bg-black/50 transition-opacity duration-200 data-[state=closed]:opacity-0 data-[state=open]:opacity-100"
      />
      <Tour.Spotlight class="rounded-lg" />
      <Tour.Positioner>
        <Tour.Content
          class="gradient-border bg-surface-raise shadow-floating ease-out-expo z-50 w-80 origin-[--transform-origin] rounded-xl p-4 transition-[opacity,transform] duration-200 data-[state=closed]:scale-95 data-[state=closed]:opacity-0 data-[state=open]:scale-100 data-[state=open]:opacity-100"
        >
          <Tour.Arrow>
            <Tour.ArrowTip />
          </Tour.Arrow>
          <div class="mb-3 flex items-start justify-between gap-2">
            <Tour.Title class="text-title-2 text-text-default" />
            <Tour.CloseTrigger
              class="text-text-hint hover:text-text-default -mt-1 -mr-1 flex aspect-square cursor-pointer rounded-lg p-1"
            >
              <Icon name="tabler:x" />
            </Tour.CloseTrigger>
          </div>
          <Tour.Description class="text-body-3 text-text-muted mb-4" />
          <div class="flex items-center justify-between">
            <Tour.ProgressText class="text-caption-1 text-text-hint" />
            <Tour.Control class="flex gap-2">
              <Tour.Actions v-slot="actions">
                <Tour.ActionTrigger
                  v-for="(action, index) in actions"
                  :key="action.label"
                  :action="action"
                  as-child
                >
                  <DesignButton
                    :variant="
                      index === actions.length - 1 ? 'primary' : 'secondary'
                    "
                    size="small"
                    :label="action.label"
                  />
                </Tour.ActionTrigger>
              </Tour.Actions>
            </Tour.Control>
          </div>
        </Tour.Content>
      </Tour.Positioner>
    </Teleport>
  </Tour.Root>
</template>

<style>
[data-scope='tour'][data-part='positioner'] {
  position: fixed;
  z-index: var(--z-index);
}

[data-scope='tour'][data-part='positioner'][data-type='dialog'] {
  inset: 0;
  width: 100%;
  margin: auto;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
