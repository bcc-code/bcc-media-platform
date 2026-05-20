<script setup lang="ts">
import type { TourStepDetails } from '@ark-ui/vue'

const inputValue = ref('')
const textareaValue = ref('')
const selectValue = ref<string[]>([])
const segmentValue = ref('one')
const dateValue = ref('')
const switchValue = ref(false)
const switchDisabled = ref(true)
const tagsValue = ref(['Vue', 'Nuxt'])
const tourRef = ref<{ start: () => void }>()
const toaster = useToast()

const uploadProgress = ref<number | null>(null)
let uploadTimer: ReturnType<typeof setInterval> | null = null

function simulateUpload() {
  if (uploadTimer) clearInterval(uploadTimer)
  uploadProgress.value = 0
  uploadTimer = setInterval(() => {
    if (uploadProgress.value === null) return
    if (uploadProgress.value >= 100) {
      clearInterval(uploadTimer!)
      uploadTimer = null
      return
    }
    uploadProgress.value = Math.min(100, uploadProgress.value + 8)
  }, 200)
}

onBeforeUnmount(() => {
  if (uploadTimer) clearInterval(uploadTimer)
})

const tourSteps: TourStepDetails[] = [
  {
    id: 'welcome',
    type: 'dialog',
    title: 'Welcome!',
    description: 'This is a quick tour of the design system components.',
    actions: [{ label: 'Start', action: 'next' }]
  },
  {
    id: 'button',
    type: 'tooltip',
    title: 'Buttons',
    description: 'These are the available button variants and sizes.',
    target: () => document.querySelector<HTMLElement>('#button'),
    actions: [
      { label: 'Back', action: 'prev' },
      { label: 'Next', action: 'next' }
    ]
  },
  {
    id: 'badge',
    type: 'tooltip',
    title: 'Badges',
    description: 'Use badges for status indicators and labels.',
    target: () => document.querySelector<HTMLElement>('#badge'),
    actions: [
      { label: 'Back', action: 'prev' },
      { label: 'Done', action: 'dismiss' }
    ]
  }
]

const selectItems = [
  { label: 'Option A', value: 'a' },
  { label: 'Option B', value: 'b' },
  { label: 'Option C', value: 'c' }
]

const segmentItems = [
  { label: 'One', value: 'one' },
  { label: 'Two', value: 'two' },
  { label: 'Three', value: 'three' }
]
</script>

<template>
  <div class="flex flex-col gap-12">
    <h1 class="text-heading-1">Design System</h1>

    <section id="button">
      <h2 class="text-heading-2 mb-3">Button</h2>
      <div class="flex gap-2">
        <DesignButton variant="primary">Primary variant</DesignButton>
        <DesignButton variant="secondary">Secondary variant</DesignButton>
        <DesignButton variant="tertiary">Tertiary variant</DesignButton>
      </div>
      <div class="mt-2 flex items-center gap-2">
        <DesignButton size="small">Small size</DesignButton>
        <DesignButton size="medium">Medium size</DesignButton>
        <DesignButton size="large">Large size</DesignButton>
      </div>
      <div class="mt-2 flex items-center gap-2">
        <DesignButton variant="primary" size="small" icon="tabler:plus">
          With icon
        </DesignButton>
        <DesignButton variant="secondary" size="medium" icon="tabler:pencil">
          With icon
        </DesignButton>
        <DesignButton variant="tertiary" size="large" icon="tabler:trash">
          With icon
        </DesignButton>
      </div>
      <div class="mt-2 flex items-center gap-2">
        <DesignButton variant="primary" intent="danger" icon="tabler:trash">
          Danger primary
        </DesignButton>
        <DesignButton variant="secondary" intent="danger" icon="tabler:trash">
          Danger secondary
        </DesignButton>
        <DesignButton variant="tertiary" intent="danger" icon="tabler:trash">
          Danger tertiary
        </DesignButton>
      </div>
    </section>

    <section id="badge">
      <h2 class="text-heading-2 mb-3">Badge</h2>
      <div class="flex items-center gap-2">
        <DesignBadge variant="success">Success</DesignBadge>
        <DesignBadge variant="warning">Warning</DesignBadge>
        <DesignBadge variant="info">Info</DesignBadge>
        <DesignBadge variant="error">Error</DesignBadge>
        <DesignBadge variant="neutral">Neutral</DesignBadge>
      </div>
    </section>

    <section id="status-indicator">
      <h2 class="text-heading-2 mb-3">Status indicator</h2>
      <div class="flex flex-col gap-3">
        <div class="flex items-center gap-4">
          <DesignStatusIndicator variant="success">
            Publisert
          </DesignStatusIndicator>
          <DesignStatusIndicator variant="info">
            Ikke oppført
          </DesignStatusIndicator>
          <DesignStatusIndicator variant="neutral">
            Utkast
          </DesignStatusIndicator>
          <DesignStatusIndicator variant="warning">
            Arkivert
          </DesignStatusIndicator>
          <DesignStatusIndicator variant="error">Feilet</DesignStatusIndicator>
        </div>
        <div class="flex items-center gap-4">
          <DesignStatusIndicator size="sm" variant="success">
            Publisert
          </DesignStatusIndicator>
          <DesignStatusIndicator size="sm" variant="info">
            Ikke oppført
          </DesignStatusIndicator>
          <DesignStatusIndicator size="sm" variant="neutral">
            Utkast
          </DesignStatusIndicator>
          <DesignStatusIndicator size="sm" variant="warning">
            Arkivert
          </DesignStatusIndicator>
          <DesignStatusIndicator size="sm" variant="error">
            Feilet
          </DesignStatusIndicator>
        </div>
      </div>
    </section>

    <section id="input">
      <h2 class="text-heading-2 mb-3">Input</h2>
      <div class="flex max-w-sm flex-col gap-4">
        <DesignInput v-model="inputValue" placeholder="Text input" />
        <DesignInput
          label="Email"
          type="email"
          placeholder="you@example.com"
          helper-text="We'll never share your email"
        />
        <DesignInput
          label="Website"
          type="url"
          placeholder="https://example.com"
          required
        />
        <DesignInput
          label="Username"
          placeholder="Enter username"
          invalid
          error-text="Username is already taken"
        />
        <DesignInput label="Read-only" placeholder="Disabled input" disabled />
      </div>
    </section>

    <section id="textarea">
      <h2 class="text-heading-2 mb-3">Textarea</h2>
      <div class="flex max-w-sm flex-col gap-4">
        <DesignTextarea
          v-model="textareaValue"
          label="Description"
          placeholder="Write something..."
          helper-text="Markdown is supported"
        />
        <DesignTextarea
          label="Required field"
          placeholder="This field is required"
          required
        />
        <DesignTextarea
          label="With error"
          placeholder="Enter feedback..."
          invalid
          error-text="Feedback must be at least 10 characters"
          :rows="2"
        />
        <DesignTextarea
          label="Disabled"
          placeholder="Disabled textarea"
          disabled
          :rows="2"
        />
      </div>
    </section>

    <section id="select">
      <h2 class="text-heading-2 mb-3">Select</h2>
      <div class="flex gap-2">
        <DesignSelect
          v-model="selectValue"
          :items="selectItems"
          placeholder="Choose an option"
        />
      </div>
    </section>

    <section id="date-picker">
      <h2 class="text-heading-2 mb-3">Date Picker</h2>
      <div class="flex max-w-sm flex-col gap-4">
        <DesignDatePicker v-model="dateValue" label="Date" />
        <DesignDatePicker label="Disabled" disabled />
      </div>
    </section>

    <section id="segment-group">
      <h2 class="text-heading-2 mb-3">Segment Group</h2>
      <DesignSegmentGroup v-model="segmentValue" :items="segmentItems" />
    </section>

    <section id="tooltip">
      <h2 class="text-heading-2 mb-3">Tooltip</h2>
      <div class="flex items-center gap-4">
        <DesignTooltip content="Top tooltip">
          <DesignButton variant="secondary" size="small"
            >Hover me (top)</DesignButton
          >
        </DesignTooltip>
        <DesignTooltip content="Bottom tooltip" placement="bottom">
          <DesignButton variant="secondary" size="small"
            >Hover me (bottom)</DesignButton
          >
        </DesignTooltip>
      </div>
    </section>

    <section id="banner">
      <h2 class="text-heading-2 mb-3">Banner</h2>
      <div class="flex flex-col gap-2">
        <DesignBanner variant="success" icon="tabler:check">
          Operation completed successfully
        </DesignBanner>
        <DesignBanner variant="warning" icon="tabler:alert-triangle">
          Please review before continuing
        </DesignBanner>
        <DesignBanner variant="info" icon="tabler:info-circle">
          Here is some useful information
        </DesignBanner>
        <DesignBanner variant="error" icon="tabler:x">
          Something went wrong
        </DesignBanner>
        <DesignBanner variant="neutral" icon="tabler:message">
          A neutral message
        </DesignBanner>
      </div>
    </section>

    <section id="switch">
      <h2 class="text-heading-2 mb-3">Switch</h2>
      <div class="flex flex-col gap-3">
        <DesignSwitch v-model="switchValue" label="Enable notifications" />
        <DesignSwitch
          v-model="switchDisabled"
          label="Disabled switch"
          disabled
        />
      </div>
    </section>

    <section id="tags-input">
      <h2 class="text-heading-2 mb-3">Tags Input</h2>
      <div class="flex max-w-sm flex-col gap-4">
        <DesignTagsInput
          v-model="tagsValue"
          label="Frameworks"
          placeholder="Add framework..."
        />
        <DesignTagsInput
          label="With max (3)"
          placeholder="Add tag..."
          :max="3"
        />
        <DesignTagsInput label="Disabled" placeholder="Disabled" disabled />
      </div>
    </section>

    <section id="toast">
      <h2 class="text-heading-2 mb-3">Toast</h2>
      <div class="flex flex-wrap gap-2">
        <DesignButton
          variant="secondary"
          size="small"
          @click="
            toaster.success({
              title: 'Success',
              description: 'Changes have been saved.'
            })
          "
        >
          Success toast
        </DesignButton>
        <DesignButton
          variant="secondary"
          size="small"
          @click="
            toaster.error({
              title: 'Error',
              description: 'Something went wrong.'
            })
          "
        >
          Error toast
        </DesignButton>
        <DesignButton
          variant="secondary"
          size="small"
          @click="
            toaster.warning({
              title: 'Warning',
              description: 'Please review before continuing.'
            })
          "
        >
          Warning toast
        </DesignButton>
        <DesignButton
          variant="secondary"
          size="small"
          @click="
            toaster.info({
              title: 'Info',
              description: 'Here is some useful information.'
            })
          "
        >
          Info toast
        </DesignButton>
        <DesignButton
          variant="secondary"
          size="small"
          @click="
            toaster.create({
              title: 'Item deleted',
              description: 'The item has been removed.',
              type: 'info',
              action: {
                label: 'Undo',
                onClick: () => {
                  toaster.success({
                    title: 'Restored'
                  })
                }
              }
            })
          "
        >
          Action toast
        </DesignButton>
      </div>
    </section>

    <section id="tour">
      <h2 class="text-heading-2 mb-3">Tour</h2>
      <DesignButton variant="secondary" size="small" @click="tourRef?.start()">
        Start tour
      </DesignButton>
      <DesignTour ref="tourRef" :steps="tourSteps" />
    </section>

    <section id="progress-circle">
      <h2 class="text-heading-2 mb-3">Progress circle</h2>
      <div class="flex items-center gap-6">
        <DesignProgressCircle />
        <DesignProgressCircle :value="25" />
        <DesignProgressCircle :value="60" />
        <DesignProgressCircle :value="100" />
        <DesignProgressCircle :value="40" :size="64" :thickness="4" />
      </div>
      <div class="mt-4 flex items-center gap-4">
        <DesignProgressCircle :value="uploadProgress" :size="56" show-value />
        <div>
          <p class="text-body-3 text-text-default">
            {{
              uploadProgress === null
                ? 'Klar til opplasting'
                : uploadProgress >= 100
                  ? 'Ferdig'
                  : 'Laster opp…'
            }}
          </p>
          <DesignButton
            class="mt-2"
            variant="secondary"
            size="small"
            @click="simulateUpload"
          >
            Simuler opplasting
          </DesignButton>
        </div>
      </div>
    </section>

    <section id="view-states">
      <h2 class="text-heading-2 mb-3">View States</h2>
      <div class="grid grid-cols-3 gap-4">
        <div class="border-border-1 rounded-xl border py-12">
          <DesignLoadingState />
        </div>
        <div class="border-border-1 rounded-xl border py-12">
          <DesignErrorState
            title="Noe gikk galt"
            description="Kunne ikke laste inn data"
          >
            <template #action>
              <DesignButton variant="secondary"> Prøv igjen </DesignButton>
            </template>
          </DesignErrorState>
        </div>
        <div class="border-border-1 rounded-xl border py-12">
          <DesignEmptyState
            title="Ingen resultater"
            description="Prøv å endre søket ditt"
          />
        </div>
      </div>
    </section>

    <section id="typography">
      <h2 class="text-heading-2 mb-3">Typography</h2>
      <div class="flex flex-col gap-3">
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            heading-1
          </span>
          <span class="text-heading-1">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            heading-2
          </span>
          <span class="text-heading-2">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            heading-3
          </span>
          <span class="text-heading-3">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            title-1
          </span>
          <span class="text-title-1">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            title-2
          </span>
          <span class="text-title-2">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            title-3
          </span>
          <span class="text-title-3">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            body-1
          </span>
          <span class="text-body-1">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            body-2
          </span>
          <span class="text-body-2">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            body-3
          </span>
          <span class="text-body-3">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            caption-1
          </span>
          <span class="text-caption-1">The quick brown fox</span>
        </div>
        <div class="flex items-baseline gap-4">
          <span class="text-caption-1 text-text-muted w-24 shrink-0">
            caption-2
          </span>
          <span class="text-caption-2">The quick brown fox</span>
        </div>
      </div>
    </section>
  </div>
</template>
