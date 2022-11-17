<template>
  <div class="form-group">
    <section class="">
      <h2 class="text-2xl">Language Prefence List</h2>
      <input v-model="contexts" class="text-black p-2 m-2" placeholder="Input New Name Here">
      <button class="rounded-xl bg-white p-2 m-2 border-4 border-slate-900 text-black" @click="addPeople">Add</button>
    </section>
    <h3>{{ 'Draggable: ' + draggingInfo }}</h3>
  </div>
  <Draggable tag="ul" :list="items"
    class="list-group text-black text-center w-full max-w-md bg-white p-[5px] mb-5 rounded-[10px] " item-key="id"
    ghost-class="ghost" @start="dragging = true" @end="dragging = false" :animation="200">
    <!-- <template #header>
        <div></div>
      </template> -->
    <template #item="{ element, index }">
      <li class="list-group-item border-1 border-slate-100 bg-slate-200">
        <i class="fa fa-align-justify handle"></i>
        <span>
          {{ element.title }}
          index: {{ element.index }} id: {{ element.id }}
        </span>
        <i class="close absolute right-10" @click="removeAt(index)">{{ t('Remove') }} &#10060;</i>
      </li>
    </template>
    <!-- <template #footer>
        <button @click="addPeople">Add</button>
      </template> -->
  </Draggable>

</template>
<script lang="ts" setup>
import { computed, ref } from 'vue'
import Draggable from 'vuedraggable'
import { useI18n } from 'vue-i18n';
const { t } = useI18n();

interface Item {
  id: number,
  title: string,
  index: string
}
const items = ref<Item[]>([
  {
    id: 0,
    title: 'Item A',
    index: '1',
  },
  {
    id: 1,
    title: 'Item B',
    index: '2',
  },
  {
    id: 2,
    title: 'Item C',
    index: '3',
  },
]);

const dragging = ref(false);
const contexts = ref('');

const draggingInfo = computed(() => dragging.value ? "under drag" : "")


const addPeople = () => {
  items.value.push(<Item>{ id: getNewID(), title: 'Item G', index: getNewIndex() });
  contexts.value = '';
}
const removeAt = (index: number) => {
  items.value.splice(index, 1)
  items.value = refreshListIndex(items.value);
}

const getNewID = () => Math.max(...items.value.map((o) => o.id)) + 1
const getNewIndex = () => (Math.max(...items.value.map((o) => parseInt(o.index))) + 1).toString()
const refreshListIndex = (lists: Item[]) => {
  var orderList = [...lists].sort((a: Item, b: Item) => a.index > b.index ? 1 : -1);
  for (var i = 0; i <= orderList.length; i++) {
    orderList[i].index = (i + 1).toString();
  }
  return orderList.sort((a: Item, b: Item) => a.id > b.id ? 1 : -1);
}

</script>

<style scoped>
.drag-el {
  background-color: #fff;
  margin-bottom: 10px;
  padding: 5px;
}

.ghost {
  opacity: 0.5;
  background: #c8ebfb;
}

.handle {
  float: left;
  padding-top: 8px;
  padding-bottom: 8px;
}
</style>