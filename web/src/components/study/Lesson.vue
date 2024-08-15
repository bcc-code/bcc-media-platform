<script lang="ts" setup>
import { onMounted, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useTitle } from '@/utils/title'
import { analytics } from '@/services/analytics'
import { useGetStudyLessonQuery } from '@/graph/generated'
import { useRoute } from 'vue-router'
import { VButton } from '..'
import Tasks from './Tasks.vue'
import More from './More.vue'
import Loader from '../Loader.vue'

export type Page = '' | 'intro' | 'tasks' | 'more'

console.log(useRoute())
const route = useRoute()
const props = defineProps<{
    episodeId: string
    lessonId: string
    subRoute: Page
}>()

const { error, fetching, data, executeQuery, ...lessonQuery } =
    useGetStudyLessonQuery({
        pause: props.lessonId == null,
        variables: { lessonId: props.lessonId, episodeId: props.episodeId },
        requestPolicy: 'network-only',
    })

const { t } = useI18n()

const { setTitle } = useTitle()

const page = ref<Page>(props.subRoute)

watch(page, (val) => {
    if (val == 'tasks') {
        executeQuery()
    }
})

onMounted(async () => {
    setTitle('')
    analytics.page({
        id: 'study',
        title: '',
    })
    var result = await lessonQuery
    var data = result.data.value
    if (props.subRoute == '' && data != null) {
        var completedTasks = data.studyLesson.progress.completed
        var totalTasks = data.studyLesson.progress.total
        if (completedTasks == 0) {
            page.value = 'intro'
        } else if (completedTasks < totalTasks) {
            page.value = 'tasks'
        } else {
            page.value = 'more'
        }
    }
})

const reload = () => {
    executeQuery()
}
</script>
<template>
    <div
        class="inline-flex flex-col space-y-6 items-center justify-start w-full h-full"
    >
        <div
            v-if="fetching"
            class="p-12 h-full flex items-center justify-center"
        >
            <Loader variant="spinner"></Loader>
        </div>
        <div v-else-if="error" class="p-12">
            <div class="text-style-title-1">Something went wrong</div>
            <div class="text-red mt-4">{{ error.message }}</div>
            <div class="text-red mt-2">{{ error.stack }}</div>
            <VButton class="mt-4" @click="() => reload()">Retry</VButton>
        </div>
        <template v-else-if="data != null">
            <transition name="fade" mode="out-in">
                <Tasks
                    v-if="page == 'intro'"
                    :lesson="data"
                    @navigate="(t) => (page = t)"
                />
                <Tasks
                    v-else-if="page == 'tasks'"
                    :lesson="data"
                    @navigate="(t) => (page = t)"
                />
                <More
                    v-else-if="page == 'more'"
                    :lesson="data"
                    @navigate="(t) => (page = t)"
                />
            </transition>
        </template>
    </div>
</template>
