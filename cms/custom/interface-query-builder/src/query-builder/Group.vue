<template>
    <div class="group">
        <div style="display: inline-block">
            <div>
                <h3>Match Operator</h3>
                <select v-model="selectedOperator" @change="update" style="text-transform: uppercase;">
                    <option v-for="op in groupOperators">{{ op }}</option>
                </select>
            </div>
            <div>
                <h3>Add child</h3>
                <VButton @click="addGroup()">+group</VButton>
                <VButton @click="addFilter()">+filter</VButton>
            </div>
            <div class="children">
                <div v-for="(v, i) in children">
                    <Group
                        v-if="isGroup(v)"
                        :value="(v as TGroup)" 
                        :fields="fields" 
                        @update:value="c => handleChildUpdate(i, c)" 
                        @delete="handleChildDelete(i)"
                    />
                    <Filter
                        v-else-if="isFilter(v)"
                        :value="(v as TFilter)"
                        :fields="fields"
                        @update:value="c => handleChildUpdate(i, c)"
                        @delete="handleChildDelete(i)"
                    />
                    <div v-else>
                        <p>Invalid child</p>
                        <VButton @click="handleChildDelete(i)">Delete</VButton>
                    </div>
                </div>
            </div>
        </div>
        <div style="display: inline-block; float: right">
            <VButton @click="$emit('delete')">Delete</VButton>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { computed, ref } from 'vue';
import { snakeToPascal, Field, Filter as TFilter, Group as TGroup, isGroup, isFilter } from '.';
import Filter from './Filter.vue';
import VButton from './VButton.vue';

const props = defineProps<{ value: TGroup, fields: Field[] }>();
const emit = defineEmits<{ 
    (e: "update:value", value: TGroup), 
    (e: "delete"),
    (e: "change")
}>();

const groupOperators = ["and", "or"];
const filterOperators = ["==", "!=", "<", "<=", ">", ">="];

const operator = computed(() => (Object.keys(props.value).filter(i => i !== "id")[0]));
const children = computed(() => {
    const value = props.value[operator.value];
    return value as (TFilter | TGroup)[];
})

const selectedOperator = ref(operator.value);

function addGroup() {
    const filterValue = {} as TGroup;
    filterValue[selectedOperator.value] = Object.assign([], children.value);
    filterValue[selectedOperator.value].push({
        "and": [],
    })
    emit("update:value", filterValue);
    emit("change");
}

function addFilter() {
    const filterValue = {} as TGroup;
    filterValue[selectedOperator.value] = Object.assign([], children.value);
    filterValue[selectedOperator.value].push({
        "==": [],
    })
    emit("update:value", filterValue);
    emit("change");
}

function update() {
    const group = Object.assign({}, props.value);
    if (selectedOperator.value !== operator.value) {
        group[selectedOperator.value] = group[operator.value]
        delete group[operator.value];
    }
    emit("update:value", group);
    emit("change");
}

function handleChildUpdate(index: number, child: TFilter | TGroup) {
    const group = Object.assign({}, props.value) as TGroup;
    group[operator.value][index] = child;
    emit("update:value", group)
    emit("change");
}

function handleChildDelete(index: number) {
    const group = Object.assign({}, props.value) as TGroup;
    group[operator.value] = group[operator.value].filter((_, i) => i !== index);
    emit("update:value", group)
    emit("change");
}

</script>
<style scoped>
.group {
    margin-top: 10px;
    padding: 10px;
    border-style: solid;
    border-color: #31363d;
    border-width: 2px;
    border-radius: 4px;
}

.children {
    margin-left: 20px;
}
</style>