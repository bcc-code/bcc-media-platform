<template>
    <div>
        <v-button @click="reload">Preview</v-button>
        <div>
            <div v-for="i in items">
                <span>{{i.type}}</span>
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
    factory: () => Promise<Item[]>;
}>()

const items = ref([] as Item[])

const reload = async () => {
    items.value = await props.factory();
    console.log(items.value);
}
</script>