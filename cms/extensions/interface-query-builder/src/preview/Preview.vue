<template>
    <div>
        <v-button style="margin-bottom:10px" :loading="loading" @click="reload">Preview</v-button>
        <div v-if="count">
            <h1>Total in collection: {{count}}</h1>
        </div>
        <div>
            <div v-for="i in items">
                <span>{{i.collection}}</span>
                <span style="margin:4px">|</span>
                <span>{{i.id}}</span>
                <span style="margin:4px">|</span>
                <span>{{i.title}}</span>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { ref } from "vue";
import { Item } from "./types";

const props = defineProps<{
    factory: () => Promise<{
        count: number,
        views: Item[]}>;
}>()

const items = ref([] as Item[])
const loading = ref(false)
const count = ref(0)

const reload = async () => {
    loading.value = true;
    const r = await props.factory()
    items.value = r.views
    count.value = r.count
    loading.value = false;
}
</script>
