<template>
	<div v-if="group">
        <h1>Filter</h1>
		<Group
            style="margin-left: 10px"
			:value="group"
			:fields="fields"
			@delete="group = null"
            @update:value="(f) => group = f"
            @change="handleChange"
		/>
        <hr class="separator"/>
        <h1>Sort by</h1>
		<div class="sort-by">
            <select v-model="sortBy" @change="handleChange">
                <option
                    v-for="field in fields"
                    :value="field.column"
                >{{field.title}}
                </option>
            </select>
            <h3>Direction</h3>
			<select v-model="sortByDirection" @change="handleChange">
                <option value="asc">Ascending</option>
                <option value="desc">Descending</option>
			</select>
		</div>
        <hr class="separator" />
        <h1>Limit</h1>
        <div class="limit">
            <input v-model="limit" @change="handleChange" type="number" />
        </div>
	</div>
	<div v-else>
		<v-button @click="clearGroup()">Create filter</v-button>
	</div>
</template>

<script lang="ts" setup>
import { v4 as uuid } from "uuid";
import { Root, fields } from ".";
import Group from "./Group.vue";
import { ref } from "vue";

const props = defineProps<{
    value: Root | null;
}>()
const emit = defineEmits<{
	(e: "update:value", value: Root | null),
}>()

const group = ref(props.value?.filter ?? null);
const sortBy = ref(props.value?.sortBy ?? null);
const sortByDirection = ref(props.value?.sortByDirection ?? null)
const limit = ref(props.value?.limit ?? null);

function handleChange(): void {
    emit('update:value', {
        id: uuid(),
        filter: group.value,
        sortBy: sortBy.value,
        sortByDirection: sortByDirection.value,
        limit: limit.value,
    })
}

function clearGroup() {
	group.value = {
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
