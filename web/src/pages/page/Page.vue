<template>
    <PageComponent
        :key="page"
        v-if="!fetching"
        :page-id="page"
        @title="updateTitle"
    ></PageComponent>
</template>
<script lang="ts" setup>
import PageComponent from "@/components/page/Page.vue"
import { useApplicationQuery } from "@/graph/generated"
import { analytics } from "@/services/analytics"
import { usePage } from "@/utils/page"
import { useTitle } from "@/utils/title"
import { ref, watch } from "vue"

const props = defineProps<{
    pageId: string
}>()

const page = ref(props.pageId)

watch(
    () => props.pageId,
    () => {
        page.value = props.pageId
    }
)

const { data, fetching } = useApplicationQuery({ variables: {} })

const { setTitle } = useTitle()

const updateTitle = (title: string) => {
    const defaultPage = data.value?.application.page?.code
    if (props.pageId && defaultPage !== props.pageId) {
        setTitle(title)
    }
    analytics.page({
        id: page.value,
        title,
    })

    const { setCurrent } = usePage()
    setCurrent(page.value)
}
</script>
