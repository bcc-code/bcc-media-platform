<template>
    <v-list>
        <v-list-item>
            <v-card>
                <v-card-title>Query Filters</v-card-title>
                <v-card-text>
                    <small>Filter dataset</small>
                    <p>
                        <v-button :loading="loadingRefreshFilters" @click="refreshFilters">Refresh</v-button>
                    </p>
                </v-card-text>
            </v-card>
        </v-list-item>
        <v-list-item>
            <v-card>
                <v-card-title>Cache</v-card-title>
                <v-card-text>
                    <v-button disabled>Clear</v-button>
                </v-card-text>
            </v-card>
        </v-list-item>
    </v-list>
</template>

<script lang="ts" setup>
import {useApi} from "@directus/extensions-sdk";
import {ref} from "vue";

withDefaults(defineProps<{
    showHeader: boolean
}>(), {showHeader: true});

const {get} = useApi()

const loadingRefreshFilters = ref(false);

const refreshFilters = async () => {
    loadingRefreshFilters.value = true
    await get("/tools/filters/refresh")
    loadingRefreshFilters.value = false
}
</script>

<style scoped>
.text {
    padding: 12px;
}

.text.has-header {
    padding: 0 12px;
}
</style>
