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
                        v-model="selectedOperator"
                        @change="update"
                        :items="filterOperators"
                    />
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
                    <v-select
                        v-if="field.type === 'string' && field.options"
                        v-model="selectedValue"
                        :items="field.options"
                        item-text="title"
                        item-value="value"
                        @change="update"
                    />
                    <v-input
                        v-else-if="selectedOperator != 'in' && selectedOperator != 'is'"
                        :type="field.type"
                        v-model="selectedValue"
                        @change="update"
                    />
                    <v-input
                        v-else
                        type="text"
                        v-model="selectedValue"
                        @change="update"
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

const field = computed(() => {
    const field = props.fields.find(f => f.column === selectedProperty.value);
    return field;
})

const filterOperators = computed(() => {
    return field.value?.type === "array" ? operatorTypes.filter(i => ["is"].includes(i)) : operatorTypes.filter(i => !["is"].includes(i))
})

function update() {
    const filter = Object.assign({}, props.value);
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
