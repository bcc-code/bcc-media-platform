<template>
    <div>
        <input type="text" v-model="name" @change="updateGroup()" placeholder="Name.."/>
        <button @click="addChild('group')">Add Group</button>
        <button @click="addChild('filter')">Add Filter</button>
        <select v-model="operator" @change="updateGroup()">
            <option v-for="op in operators">{{op}}</option>
        </select>
        <div class="children">
            <Child v-for="(child, i) in group.children" :child="child" @update:child="c => updateChild(i, c)" @delete="deleteChild(i)"/>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { Type, Group, Child as TChild } from './types';
import Child from "./child.vue";
import { ref } from 'vue';

const props = defineProps<{
    group: Group;
}>();

const name = ref(props.group.name)
const operator = ref(props.group.operator);

const operators = ["and", "or"]

const emit = defineEmits<{(e: "update:group", group: Group)}>();

function addChild(type: Type) {
    const group = Object.assign({}, props.group)
    switch (type) {
        case "filter":
            group.children.push({
                type,
                property: "",
                operator: "eq",
                value: "",
            })
            break;
        case "group":
            group.children.push({
                type,
                children: [],
                name: "",
                operator: "and",
            })
            break;
    }
    console.log("ADDING CHILD")
    emit("update:group", group)
}

function updateChild(index: number, child: TChild) {
    const group = Object.assign({}, props.group)
    group.children[index] = child;
    emit("update:group", group);
}

function deleteChild(index: number) {
    const group = Object.assign({}, props.group)
    delete group.children[index];
    emit("update:group", group);
}

function updateGroup() {
    emit("update:group", {
        type: "group",
        children: props.group.children,
        name: name.value,
        operator: operator.value,
    })
}
</script>