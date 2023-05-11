<template>
    <div class="filter">
        <div style="width: 100%;">
            <h1>FILTER</h1>
            <div class="flex">
                <div>
                    <FieldSelector
                        :value="selectedProperty"
                        @update:value="v => {selectedProperty = v; update()}"
                        :fields="fields"
                    ></FieldSelector>
                </div>
                <div v-if="field">
                    <h3>Operator</h3>
                    <v-select
                        :modelValue="selectedOperator"
                        @update:modelValue="(v) => {selectedOperator = v; update()}"
                        :items="filterOperators"
                    />
                    <v-checkbox
                        v-if="field.type === 'datetime-local'"
                        v-model="relative"
                        label="Relative"
                    ></v-checkbox>
                    <!-- <select
                        v-model="selectedOperator"
                        @change="update"
                        style="text-transform: uppercase;"
                    >
                        <option v-for="op in filterOperators">{{ op }}</option>
                    </select> -->
                </div>
                <div v-if="field">
                    <h3>Value</h3>
                    <div v-if="field.type === 'datetime-local' && relative">
                        <v-input
                            type="text"
                            :modelValue="selectedValue?.replace('relative:', '').replace('relativeneg:', '')"
                            @update:modelValue="(v) => {selectedValue = 'relative' + (relativeNegative ? '-' : '') + ':' + (v ?? ''); update()}"
                        />
                        <v-checkbox
                            label="Negative"
                            v-model="relativeNegative"
                        />
                        <small>For example "2 days" or "2 hours"</small>
                    </div>
                    <v-select
                        v-else-if="field.type === 'string' && field.options"
                        :modelValue="selectedValue"
                        @update:modelValue="(v) => {selectedValue = v; update()}"
                        :items="field.options"
                        item-text="title"
                        item-value="value"
                    />
                    <v-input
                        v-else-if="selectedOperator != 'in' && selectedOperator != 'is'"
                        :type="field.type"
                        :modelValue="selectedValue"
                        @update:modelValue="(v) => {selectedValue = v; update()}"
                    />
                    <v-input
                        v-else
                        type="text"
                        :modelValue="selectedValue"
                        @update:modelValue="(v) => {selectedValue = v; update()}"
                    ></v-input>
                </div>
            </div>
        </div>
        <div>
            <v-button @click="$emit('delete')">Delete</v-button>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { computed, ref } from 'vue';
import { Field, Filter as TFilter, filterOperators as operatorTypes, Variable } from '.';
import FieldSelector from './FieldSelector.vue';

const props = defineProps<{ value: TFilter, fields: Field[] }>();
const emit = defineEmits<{
    (e: "update:value", value: TFilter),
    (e: "delete"),
    (e: "change")
}>();

const operator = computed(() => (Object.keys(props.value).filter(i => i !== "id")[0]));

const selectedOperator = ref(operator.value);
const selectedProperty = ref((((props.value as TFilter)[operator.value][0] as Variable)?.var ?? null) as string | null)
const selectedValue = ref(props.value[operator.value][1] as string | null);

const relative = ref(selectedValue.value?.toString().startsWith("relative"))
const relativeNegative = ref(selectedValue.value?.toString().startsWith("relativeneg"))

const field = computed(() => {
    const field = props.fields.find(f => f.column === selectedProperty.value);
    return field;
})

const filterOperators = computed(() => {
    return field.value?.supportedOperators
})

function update() {
    const filter = Object.assign({}, props.value);
    if (field.value && field.value?.supportedOperators.includes(selectedOperator.value) !== true) {
        selectedOperator.value = field.value?.supportedOperators[0];
    }
    if (selectedOperator.value !== operator.value) {
        filter[selectedOperator.value] = filter[operator.value]
        delete filter[operator.value];
    }
    if (selectedProperty.value !== null) {
        filter[selectedOperator.value][0] = { var: selectedProperty.value };
    }
    if (selectedValue.value !== null) {
        if (selectedOperator.value === "in") {
            filter[selectedOperator.value][1] = selectedValue.value?.split(",") ?? [];
        } else {
            filter[selectedOperator.value][1] = selectedValue.value;
        }
    }
    emit("update:value", filter);
    emit("change");
}
</script>
<style scoped>
.filter {
    margin-top: 10px;
    padding: 10px;
    width: 100%;
    display: flex;
    border-style: solid;
    border-color: #31363d;
    border-width: 2px;
    border-radius: 4px;
}
</style>
