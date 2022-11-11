<template>
    <PageComponent
        class="mb-16"
        v-if="!fetching"
        :page-id="props.pageId"
        @title="updateTitle"
    ></PageComponent>
</template>
<script lang="ts" setup>
import PageComponent from "@/components/page/Page.vue"
import { useApplicationQuery } from "@/graph/generated"
import { useTitle } from "@/utils/title"

const props = defineProps<{
    pageId: string
}>()

const { data, fetching } = useApplicationQuery()

const { setTitle } = useTitle()

const updateTitle = (title: string) => {
    const defaultPage = data.value?.application.page?.code
    if (props.pageId && defaultPage !== props.pageId) {
        setTitle(title)
    }
}
</script>
