<script lang="ts" setup>
export interface Languag {
  index: number
}
export interface Languag extends Language {
}
import { Language, languages } from '@/services/language';
import { Dialog, DialogPanel, DialogTitle, DialogDescription, TransitionChild, TransitionRoot, TabGroup, TabList, Tab, TabPanels, TabPanel } from '@headlessui/vue'
import CxtLangPrefDragList from '@/components/settings/CxtLangPrefDragList.vue';
import LanguageSelector from '@/components/settings/LangSelector.vue';
import { ref, computed } from 'vue';
import { useI18n } from 'vue-i18n';
const { t } = useI18n();


const getLangPreList: (language: Language) => Languag[] = function (language) {
  var index = 1;
  let result: Languag[] = [];
  for (var i = 0; i < languages.value.length; i++) {
    let obj: Languag = {
      index: index++,
      code: language.code,
      name: language.name,
      english: language.english
    }
    result.push(obj)
  }
  return result ?? languages;
}

const categories = ref({
  'audioLanguage': languages,
  'subtitleLanguage': languages,
  // 'contentLangPreList': getLangPreList
})

const langPreList = ref({
  'contentLangPreList': getLangPreList
})

const contentLangPreference = ref({
  contentLangPreList: [languages]
})

const audSelected = ref(getLocalAudSelected);
const subSelected = ref(getLocalSubSelected);

const curretnCategory = ref(t('audioLanguage')); //inital value of the tab

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

const emits = defineEmits(["closeDialog"]);
function dialogOnClose() {
  emits("closeDialog");
}

interface props {
  show: boolean
}
const props = defineProps<props>()

</script>
<template>

  <TransitionRoot as="template" :show="props.show" enter="duration-300 ease-out" enter-from="opacity-0"
    enter-to="opacity-100" leave="duration-200 ease-in" leave-from="opacity-100" leave-to="opacity-0"
    class="absolute top-90">
    <Dialog as="div" @close="dialogOnClose" class="relative z-10">
      <!-- Background overlay -->
      <TransitionChild as="template" enter="transition-opacity ease-linear duration-300" enter-from="opacity-0"
        enter-to="opacity-100" leave="transition-opacity ease-linear duration-300" leave-from="opacity-100"
        leave-to="opacity-0">
        <div class="fixed inset-0 bg-black bg-opacity-25" />
      </TransitionChild>
      <!-- Dialog Panel -->
      <div class="fixed inset-0 overflow-y-auto ">
        <div class="flex min-h-full items-center justify-center p-4 text-center">
          <TransitionChild as="template" enter-from="-translate-y-full" enter-to="translate-y-0"
            enter="duration-300 ease-out" leave="duration-200 ease-in" leave-from="translate-y-0"
            leave-to="-translate-y-full" class="min-w-[500px] ">
            <DialogPanel
              class="w-full max-w-md transform overflow-hidden rounded-2xl bg-blue-600 p-6 text-left align-middle shadow-xl transition-all">
              <DialogTitle class="text-4xl text-center font-bold mb-10">{{t('settings.profileSetting')}}</DialogTitle>
              <DialogDescription>

                <CxtLangPrefDragList />
                <TabGroup>
                  <TabList class="flex space-x-1 rounded-xl bg-blue-900/20 p-1">
                    <Tab v-for="category in Object.keys(categories)" as="template" :key="category"
                      @click="curretnCategory=category;" v-slot="{ selected }">
                      <button :class="[
                        'w-full rounded-lg py-2.5 text-sm font-medium leading-5 text-blue-700',
                        'ring-white ring-opacity-60 ring-offset-2 ring-offset-blue-400 focus:outline-none focus:ring-2',
                        selected
                          ? 'bg-white shadow'
                          : 'text-blue-100 hover:bg-white/[0.12] hover:text-white',
                      ]">
                        {{ t(`settings.categories.${category}`) }}
                      </button>
                    </Tab>
                  </TabList>
                  <TabPanels class="mt-2">
                    <TabPanel v-for="(items, idx) in Object.values(categories)" v-slot="{ selected}" :key="idx" :class="[
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
          <!-- further -->


        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>