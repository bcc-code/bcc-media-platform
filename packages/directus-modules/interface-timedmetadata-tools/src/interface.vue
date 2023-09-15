<script lang="ts" setup>
import { useApi } from "@directus/extensions-sdk"
import { ref } from "vue"

const props = defineProps<{
    primaryKey: string
    collection: string
}>()

const api = useApi()

const loading = ref(false)

const imported = ref<boolean>()

const importFromAsset = async () => {
    loading.value = true
    imported.value = (
        await api.post("/tools/timedmetadata/import", {
            episodeId: props.primaryKey,
        })
    ).data
    setTimeout(() => {
        imported.value = undefined
    }, 5000)
    loading.value = false
}
</script>
<template>
    <div>
        <div>
            <v-button @click="importFromAsset" :loading="loading"
                >Import from asset</v-button
            >
        </div>
        <div>
            <small v-if="imported === true" style="color: lime"
                >Imported successfully</small
            >
            <small v-if="imported === false" style="color: red"
                >Failed to import from asset</small
            >
        </div>
    </div>
</template>
