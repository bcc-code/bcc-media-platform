<template>
	<div v-if="filter">
        <h1>Filter</h1>
		<Filter 
            style="margin-left: 10px"
			:value="filter"
			:fields="fields" 
			@delete="filter = null"
            @update:value="(f) => filter = f"
            @change="handleChange"
		/>
        <hr class="separator"/>
        <h1>Sort by</h1>
		<div class="sort-by">
            <select v-model="sortBy" @change="handleChange">
                <option
                    v-for="field in fields"
                    :value="field.name"
                >{{snakeToPascal(field.name)}}</option>
            </select>
            <h3>Direction</h3>
			<select v-model="sortByDirection" @change="handleChange">
                <option value="asc">Ascending</option>
                <option value="desc">Descending</option>
			</select>
		</div>
	</div>
	<div v-else>
		<VButton @click="clearGroup()">Create filter</VButton>
	</div>
</template>

<script lang="ts" setup>
import { v4 as uuid } from "uuid";
import { snakeToPascal, Field as TField, Root } from ".";
import Filter from "./Filter.vue";
import { useApi } from "@directus/extensions-sdk";
import { Field } from "@directus/shared/types";
import { ref } from "vue";
import VButton from "./VButton.vue";

const props = defineProps<{
    fieldCollection: string;
    value: Root | null;
}>()
const emit = defineEmits<{
	(e: "input", value: Root | null),
}>()

const fields = ref([] as TField[]);
const filter = ref(props.value?.filter ?? null);
const sortBy = ref(props.value?.sortBy ?? null);
const sortByDirection = ref(props.value?.sortByDirection ?? null)

const types = {
    string: "text",
    text: "text",
    integer: "number",
    date: "date",
    dateTime: "datetime-local",
};

((await useApi().get("/fields")).data.data as Field[]).forEach(field => {
    if (field.collection === props.fieldCollection && !field.meta?.hidden) {
        if (!Object.keys(types).includes(field.type)) {
            return;
        }

        fields.value.push({
            name: field.field,
            type: types[field.type] ?? "text"
        } as TField)
    }
})

function handleChange(): void {
    emit('input', {
        id: uuid(),
        filter: filter.value,
        sortBy: sortBy.value,
        sortByDirection: sortByDirection.value,
    })
}

function clearGroup() {
	filter.value = {
        "and": [],
    };
    handleChange();
}

</script>
<style>
h1 {
    font-size: 18px;
    font-weight: 700;
}

.sort-by {
    padding: 10px;
}

.separator {
    margin: 10px;
    border-color: #31363d;
}
</style>
