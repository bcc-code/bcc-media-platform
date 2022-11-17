<script lang="ts" setup>
import { ref, toRefs } from 'vue';
import { useI18n } from 'vue-i18n';
import { Language } from '@/services/language';
import { Languag } from '@/pages/setting/SettingContent.vue';
const { t } = useI18n();

interface props {
  langlist: Language[]| Languag[],
  // langlist: Language[]
  selectedtab: string,
  selectedoption: string
}

// const itemsList = ref([
//         {
//           id: 0,
//           title: 'Item A',
//           list: 1,
//         },
//         {
//           id: 1,
//           title: 'Item B',
//           list: 1,
//         },
//         {
//           id: 2,
//           title: 'Item C',
//           list: 2,
//         },
//       ])

const props = withDefaults(defineProps<props>(), {
  selectedoption: 'en'
})
var { selectedoption } = toRefs(props)
  
  function updateHandler(code: string) {
    selectedOpt.value = code
    // selectedoption.value = code
    switch (props.selectedtab) {
    case 'audioLanguage':
      localStorage.setItem('audSelected', code)
      break;
    case 'subtitleLanguage':
      localStorage.setItem('subSelected', code)
      break;
  }
  }
  const selectedOpt = ref(props.selectedoption);
</script>

<template>
  <!-- v-if="selectedtab == 'contentLangPreList'" -->
  <div  class="text-black">
    <!-- {{langlist}} -->
    
    <!-- <p>contentLangPreList</p> -->
  </div>
  <ul>
    <li v-for="item in (langlist)" @click="updateHandler(item.code)"   
      class="relative rounded-md p-3 hover:bg-slate-100 text-black">
      <section class="flex">
        <div class="">
          <h3 class="text-sm font-medium leading-5">
            {{ item.name }}
          </h3>
          <h5 v-if="item.english" class="mt-1 flex space-x-1 text-xs font-normal leading-4 text-slate-500 ">({{
          item.english }})</h5>
        </div>
        <img class="absolute right-5 h-10 w-10 mx-4" v-if="selectedOpt === item.code"
          src="data:image/png;base64,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"
          alt="">
      </section>

      <a href=" #" :class="[
        'absolute inset-0 rounded-md',
        'ring-blue-400 focus:z-10 focus:outline-none focus:ring-2',
      ]" />
    </li>
  </ul>
</template>