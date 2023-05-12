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
            <v-select 
                v-model="sortBy"
                @change="handleChange"
                :items="fields"
                item-text="title"
                item-value="column"
            />
            <h3>Direction</h3>
            <v-select 
                v-model="sortByDirection"
                :items="[{title: 'Ascending', column: 'asc'}, {title: 'Descending', column: 'desc'}]"
                item-text="title"
                item-value="column"
            />
		</div>
        <hr class="separator" />
        <h1>Limit</h1>
        <div class="limit">
            <v-input v-model="limit" @change="handleChange" type="number" />
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
import { ref, watch } from "vue";

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

watch(() => [sortBy.value, sortByDirection.value], handleChange)

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
