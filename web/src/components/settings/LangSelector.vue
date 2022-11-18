<script lang="ts" setup>
import { ref } from 'vue';
import { Language } from '@/services/language';
import { LanguageWithIndex } from '@/pages/setting/SettingContent.vue';

interface props {
  langlist: Language[] | LanguageWithIndex[],
  selectedtab: string,
  selectedoption: string
}

const props = withDefaults(defineProps<props>(), {
  selectedoption: 'en'
})

const selectedOpt = ref(props.selectedoption);

function updateHandler(code: string) {
  selectedOpt.value = code //set the local storage here
  switch (props.selectedtab) {
    case 'audioLanguage':
      localStorage.setItem('audSelected', code)
      break;
    case 'subtitleLanguage':
      localStorage.setItem('subSelected', code)
      break;
  }
}

</script>

<template>
  <ul>
    <li v-for="item in (langlist)" @click="updateHandler(item.code)"
      class="relative rounded-md p-3 hover:bg-slate-100 text-black">
      <section class="flex">
        <div class="">
          <h3 class="text-sm font-medium leading-5">
            {{ item.name }}
          </h3>
          <h5 v-if="item.english" class="mt-1 flex space-x-1 text-xs font-normal leading-4 text-slate-500 ">({{
              item.english
          }})</h5>
        </div>
        <span class="absolute right-5 h-10 w-10 mx-4" v-if="selectedOpt === item.code">Selected</span>
      </section>
      <a href=" #" :class="[
        'absolute inset-0 rounded-md',
        'ring-blue-400 focus:z-10 focus:outline-none focus:ring-2',
      ]" />
    </li>
  </ul>
</template>