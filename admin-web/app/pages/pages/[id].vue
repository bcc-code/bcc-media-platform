<script setup lang="ts">
import { VueDraggable } from 'vue-draggable-plus'

const route = useRoute()

const page = computed(() => mockPages.find((p) => p.id === route.params.id))

useHead({ title: () => page.value?.title ?? 'Rediger side' })

const sections = ref<PageSection[]>([])

watchEffect(() => {
  if (page.value) {
    sections.value = [...page.value.sections]
  }
})

const addDialogOpen = ref(false)

function addSection(section: PageSection) {
  sections.value.push(section)
}

function removeSection(index: number) {
  sections.value.splice(index, 1)
}

function updateSection(index: number, section: PageSection) {
  sections.value[index] = section
}
</script>

<template>
  <div v-if="page" class="flex gap-10">
    <div class="flex max-w-5xl flex-1 flex-col gap-8">
      <div>
        <BackButton to="/pages" label="Tilbake til sider" />
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-heading-2 text-text-default">{{ page.title }}</h1>
            <p class="text-body-3 text-text-hint mt-1">{{ page.code }}</p>
          </div>
          <DesignButton icon="tabler:plus" @click="addDialogOpen = true">
            Legg til seksjon
          </DesignButton>
        </div>
      </div>

      <section>
        <h2 class="text-title-1 text-text-default mb-4">
          Seksjoner ({{ sections.length }})
        </h2>

        <DesignEmptyState
          v-if="sections.length === 0"
          icon="tabler:layout"
          title="Ingen seksjoner"
          description="Legg til en seksjon for a komme i gang"
        />

        <VueDraggable
          v-else
          v-model="sections"
          handle=".drag-handle"
          :animation="200"
          ghost-class="opacity-30"
          class="flex flex-col gap-2"
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
    </div>

    <aside class="hidden lg:block">
      <PageDevicePreview :sections="sections" />
    </aside>

    <AddSectionDialog v-model:open="addDialogOpen" @add="addSection" />
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Siden ble ikke funnet.
  </div>
</template>
