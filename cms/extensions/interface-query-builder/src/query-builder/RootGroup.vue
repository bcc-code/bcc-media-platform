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
        <h1>Deboost Factor</h1>
        <div class="limit">
            <v-input v-model="deboostFactor" @change="handleChange" type="number" min="0" max="100" suffix="%" />
            <small style="display:block;margin-top:4px;color:#888;">
              Controls how likely items tagged with the deboost tag are to appear at the top. 0% means such items will never be deboosetd and are treated the same as untagged items. 100% means such items are always deboosted, and should generally appear at the botton.
              For example, 30% gives tagged items a 30% chance to be pushed to the end of the list.
            </small>
        </div>
        <h1>Deboost Tag</h1>
        <div class="limit">
            <v-input v-model="deboostTag" @change="handleChange" type="text" placeholder="e.g. serie" />
            <small style="display:block;margin-top:4px;color:#888;">
                Only items containing this tag in their tags array will be affected by the deboost factor above.
            </small>
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
const deboostFactor = ref(props.value?.deboostFactor ?? null);
const deboostTag = ref(props.value?.deboostTag ?? "");

watch(() => [sortBy.value, sortByDirection.value], handleChange)

function handleChange(): void {
    emit('update:value', {
        id: uuid(),
        filter: group.value,
        sortBy: sortBy.value,
        sortByDirection: sortByDirection.value,
        limit: limit.value,
        deboostFactor: deboostFactor.value,
        deboostTag: deboostTag.value,
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
