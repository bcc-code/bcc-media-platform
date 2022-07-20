<template>
    <div class="filter">
        <div v-if="isGroup">
            <div>
                <h3>OPERATOR</h3>
                <select v-model="selectedOperator" @change="update" style="text-transform: uppercase;">
                    <option v-for="op in groupOperators">{{ op }}</option>
                </select>
            </div>
            <div>
                <h3>ADD CHILD</h3>
                <button @click="addGroup()">+group</button>
                <button @click="addFilter()">+filter</button>
            </div>
            <div class="children">
                <div v-for="(v, i) in children">
                    <Filter :value="v" :fields="fields" @update:value="c => handleChildUpdate(i, c)" @delete="handleChildDelete(i)"></Filter>
                </div>
            </div>
        </div>
        <div v-else>
            <h1>FILTER</h1>
            <div class="flex">
                <div>
                    <h3>PROPERTY</h3>
                    <select v-model="selectedProperty" @change="update"
                        placeholder="Property...">
                        <option v-for="prop in fields.sort((a,b) => (a.name > b.name ? 1 : -1))" :key="prop.name" :value="prop.name">{{ snakeToPascal(prop.name) }}</option>
                    </select>
                </div>
                <div>
                    <h3>OPERATOR</h3>
                    <select v-model="selectedOperator" @change="update" style="text-transform: uppercase;">
                        <option v-for="op in filterOperators">{{ op }}</option>
                    </select>
                </div>
                <div>
                    <h3>VALUE</h3>
                    <input :type="fieldType" v-model="selectedValue" @change="update"/>
                </div>
            </div>
        </div>
        <div>
            <button @click="$emit('delete')">Delete</button>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { computed, ref } from 'vue';
import { Field, FilterValue } from './types';

const props = defineProps<{ value: FilterValue, fields: Field[] }>();
const emit = defineEmits<{ (e: "update:value", value: FilterValue), (e: "delete")}>();

const groupOperators = ["and", "or"];
const filterOperators = ["==", "!=", "===", "!==", "<", "<=", ">", ">="];

const operator = computed(() => (Object.keys(props.value).filter(i => i !== "id")[0]));
const isGroup = computed(() => groupOperators.includes(operator.value));
const children = computed(() => {
    const value = props.value[operator.value];
    if (Array.isArray(value)) {
        return value as FilterValue[];
    }
    return [];
})

const selectedOperator = ref(operator.value);
const selectedProperty = ref((isGroup.value ? null : props.value[operator.value][0]?.var ?? null) as string | null)
const selectedValue = ref(isGroup.value ? null : props.value[operator.value][1] as string | null);

const fieldType = computed(() => {
    if (isGroup.value) {
        return "text";
    }
    const field = props.fields.find(f => f.name === selectedProperty.value);
    return field?.type ?? "text";
})

const snakeToPascal = (string: string) => {
    return string.split("/")
        .map(snake => snake.split("_")
            .map(substr => substr.charAt(0)
                .toUpperCase() +
                substr.slice(1))
            .join(""))
        .join("/");
};

function addGroup() {
    const filterValue = {} as FilterValue;
    filterValue[selectedOperator.value] = Object.assign([], children.value);
    filterValue[selectedOperator.value].push({
        "and": [],
    })
    emit("update:value", filterValue);
}
function addFilter() {
    const filterValue = {} as FilterValue;
    filterValue[selectedOperator.value] = Object.assign([], children.value);
    filterValue[selectedOperator.value].push({
        "==": [],
    })
    emit("update:value", filterValue);
}
function update() {
    const filter = Object.assign({}, props.value);
    if (selectedOperator.value !== operator.value) {
        filter[selectedOperator.value] = filter[operator.value]
        delete filter[operator.value];
    }
    if (!isGroup.value) {
        filter[selectedOperator.value][0] = { var: selectedProperty.value };
        filter[selectedOperator.value][1] = selectedValue.value;
    }
    emit("update:value", filter);
}

function handleChildUpdate(index: number, child: FilterValue) {
    const filter = Object.assign({}, props.value) as FilterValue;
    filter[operator.value][index] = child;
    emit("update:value", filter)
}

function handleChildDelete(index: number) {
    const filter = Object.assign({}, props.value) as FilterValue;
    filter[operator.value] = filter[operator.value].filter((_, i) => i !== index);
    emit("update:value", filter)
}

</script>
<style scoped>
.filter {
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