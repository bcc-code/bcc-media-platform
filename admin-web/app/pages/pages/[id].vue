<script setup lang="ts">
import { VueDraggable } from 'vue-draggable-plus'

const route = useRoute()
const { pages, update, setSections, remove } = usePages()
const toaster = useToast()
const confirm = useConfirm()

const page = computed(() => pages.value.find((p) => p.id === route.params.id))

useHead({ title: () => page.value?.title ?? 'Rediger side' })

const status = ref<Status>(page.value?.status ?? 'draft')
watch(
  () => page.value?.status,
  (value) => {
    if (value) status.value = value
  }
)
watch(status, (value) => {
  if (page.value && value !== page.value.status) {
    update(page.value.id, { status: value })
  }
})

const sections = ref<PageSection[]>([])

watchEffect(() => {
  if (page.value) sections.value = [...page.value.sections]
})

// Persist any structural change straight back to the store.
function commit() {
  if (page.value) setSections(page.value.id, [...sections.value])
}

const addDialogOpen = ref(false)
const detailsOpen = ref(false)

function addSection(section: PageSection) {
  sections.value.push(section)
  commit()
}

function removeSection(index: number) {
  sections.value.splice(index, 1)
  commit()
}

function updateSection(index: number, section: PageSection) {
  sections.value[index] = section
  commit()
}

function saveDetails(data: {
  code: string
  title: string
  description: string | null
  applicationCode: string
}) {
  if (!page.value) return
  update(page.value.id, data)
  toaster.value.success({ title: 'Sideinnstillinger lagret' })
}

async function handleDelete() {
  if (!page.value) return
  const ok = await confirm({
    title: 'Slett siden?',
    description: 'Alle seksjonene på siden blir borte.',
    confirmLabel: 'Slett',
    intent: 'danger'
  })
  if (!ok) return
  remove(page.value.id)
  toaster.value.success({ title: 'Side slettet' })
  navigateTo('/pages')
}
</script>

<template>
  <div v-if="page" class="flex gap-10">
    <div class="flex max-w-3xl flex-1 flex-col gap-8">
      <div>
        <BackButton to="/pages" label="Tilbake til sider" />
        <div class="flex items-start justify-between gap-4">
          <div class="min-w-0">
            <h1 class="text-heading-2 text-text-default truncate">
              {{ page.title }}
            </h1>
            <div class="mt-1 flex items-center gap-2">
              <code class="text-body-3 text-text-hint">{{ page.code }}</code>
              <span class="text-text-hint">&middot;</span>
              <span class="text-body-3 text-text-hint">
                {{ applicationLabel(page.applicationCode) }}
              </span>
            </div>
          </div>
          <div class="flex shrink-0 items-center gap-3">
            <DesignButton
              variant="secondary"
              size="small"
              icon="tabler:adjustments"
              @click="detailsOpen = true"
            >
              Innstillinger
            </DesignButton>
            <StatusSelector v-model="status" />
          </div>
        </div>
      </div>

      <section>
        <div class="mb-4 flex items-center justify-between">
          <h2 class="text-title-1 text-text-default">
            Seksjoner ({{ sections.length }})
          </h2>
          <DesignButton icon="tabler:plus" @click="addDialogOpen = true">
            Legg til seksjon
          </DesignButton>
        </div>

        <DesignEmptyState
          v-if="sections.length === 0"
          icon="tabler:layout"
          title="Ingen seksjoner"
          description="Legg til en seksjon for å komme i gang"
        />

        <VueDraggable
          v-else
          v-model="sections"
          handle=".drag-handle"
          :animation="200"
          ghost-class="opacity-30"
          class="flex flex-col gap-2"
          @end="commit"
        >
          <PageSectionCard
            v-for="(section, index) in sections"
            :key="section.id"
            :section="section"
            :index="index"
            @remove="removeSection(index)"
            @update="updateSection(index, $event)"
          />
        </VueDraggable>
      </section>

      <div class="border-border-1 flex border-t pt-6">
        <DesignButton
          variant="tertiary"
          intent="danger"
          icon="tabler:trash"
          @click="handleDelete"
        >
          Slett siden
        </DesignButton>
      </div>
    </div>

    <aside class="hidden lg:block">
      <PageDevicePreview :sections="sections" />
    </aside>

    <AddSectionDialog v-model:open="addDialogOpen" @add="addSection" />
    <PageDetailsDialog
      v-model:open="detailsOpen"
      :page="page"
      @save="saveDetails"
    />
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Siden ble ikke funnet.
  </div>
</template>
