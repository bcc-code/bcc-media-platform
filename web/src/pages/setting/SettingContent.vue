<script lang="ts" setup>
export interface LanguageWithIndex {
  index: number
}
export interface LanguageWithIndex extends Language {}
//LanguageWithIndex interface is merged by the Language type and custome index prop

import { Language, languages } from '@/services/language';
import { Dialog, DialogPanel, DialogTitle, DialogDescription, TransitionChild, TransitionRoot, TabGroup, TabList, Tab, TabPanels, TabPanel } from '@headlessui/vue'
import LanguageSelector from '@/components/settings/LangSelector.vue';
import { ref, onMounted } from 'vue';
import { useI18n } from 'vue-i18n';
const { t } = useI18n();

interface props {
  show: boolean
}

const props = defineProps<props>()

const categories = ref({
  'audioLanguage': languages,
  'subtitleLanguage': languages,
})
const audSelected = ref(getLocalAudSelected);
const subSelected = ref(getLocalSubSelected);
const curretnCategory = ref(t('audioLanguage')); //inital value of the tab

const emits = defineEmits(["closeDialog"]);

function getLocalAudSelected() {
  if (localStorage.getItem('audSelected') == null) {
    localStorage.setItem('audSelected', 'en')
  }
  var result: string = localStorage.getItem('audSelected') ?? 'en'
  return result;
}
function getLocalSubSelected() {
  if (localStorage.getItem('subSelected') == null) {
    localStorage.setItem('subSelected', 'en')
  }
  var result: string = localStorage.getItem('subSelected') ?? 'en'
  return result;
}
function getSelectedOption() {
  switch (curretnCategory.value) {
    case 'audioLanguage':
      return audSelected.value();
    case 'subtitleLanguage':
      return subSelected.value();
    default:
      return 'en';
  }
}
</script>

<template>

  <TransitionRoot as="template" :show="props.show" enter="duration-300 ease-out" enter-from="opacity-0"
    enter-to="opacity-100" leave="duration-200 ease-in" leave-from="opacity-100" leave-to="opacity-0"
    class="absolute top-90">
    <Dialog as="div" @close="emits('closeDialog')" class="relative z-10">
      <!-- Background overlay -->
      <TransitionChild as="template" enter="transition-opacity ease-linear duration-300" enter-from="opacity-0"
        enter-to="opacity-100" leave="transition-opacity ease-linear duration-300" leave-from="opacity-100"
        leave-to="opacity-0">
        <div class="fixed inset-0 bg-black bg-opacity-25" />
      </TransitionChild>
      <!-- Dialog Panel -->
      <div class="flex min-h-full items-center justify-center p-4 text-center fixed inset-0 overflow-y-auto">
        <TransitionChild as="template" enter-from="-translate-y-full" enter-to="translate-y-0"
          enter="duration-300 ease-out" leave="duration-200 ease-in" leave-from="translate-y-0"
          leave-to="-translate-y-full" class="min-w-[500px] ">
          <DialogPanel
            class="w-full max-w-md transform overflow-hidden rounded-2xl bg-blue-600 p-6 text-left align-middle shadow-xl transition-all">
            <DialogTitle class="text-4xl text-center font-bold mb-6">{{ t('settings.profileSetting') }}</DialogTitle>
            <DialogDescription>
              <TabGroup>
                <TabList class="flex space-x-1 rounded-xl bg-blue-900/20 p-1">
                  <Tab v-for="category in Object.keys(categories)" as="template" :key="category"
                    @click="curretnCategory = category;" v-slot="{ selected }">
                    <button :class="[
                      'w-full rounded-lg py-2.5 text-sm font-medium leading-5 text-blue-700 ring-white ring-opacity-60 ring-offset-2 ring-offset-blue-400 focus:outline-none focus:ring-2',
                      selected
                        ? 'bg-white shadow'
                        : 'text-blue-100 hover:bg-white/[0.12] hover:text-white',
                    ]">
                      {{ t(`settings.categories.${category}`) }}
                    </button>
                  </Tab>
                </TabList>
                <TabPanels class="mt-2">
                  <TabPanel v-for="(items, idx) in Object.values(categories)" :key="idx" :class="[
                    'rounded-xl bg-white p-3 ring-[white] ring-opacity-60 ring-offset-2', 'ring-offset-blue-400 focus:outline-none focus:ring-2',
                  ]">
                    <LanguageSelector :langlist="items" :selectedtab="curretnCategory"
                      :selectedoption="getSelectedOption()" />
                  </TabPanel>
                </TabPanels>
              </TabGroup>
            </DialogDescription>
          </DialogPanel>
        </TransitionChild>
      </div>
    </Dialog>
  </TransitionRoot>
</template>