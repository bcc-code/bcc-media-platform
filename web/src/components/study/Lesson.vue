<template>
    <div class="inline-flex flex-col space-y-6 items-center justify-start w-full h-screen">
        <div v-if="fetching" class="p-12">
            Loading
        </div>
        <div v-else-if="(error != null)" class="p-12">
            <div class="text-style-title-1">Something went wrong</div>
            <div class="text-red mt-4">{{ error.message }}</div>
            <div class="text-red mt-2">{{ error.stack }}</div>
            <VButton class="mt-4" @click="() => reload()">Retry</VButton>
        </div>
        <template v-if="data != null">
            {{ page }}
            <Tasks v-if="page == 'intro'" :lesson="data" />
            <Tasks v-if="page == 'tasks'" :lesson="data" />
        </template>
    </div>
</template>
<script lang="ts" setup>
import { computed, onMounted, ref } from "vue"
import { useI18n } from "vue-i18n"
import { useTitle } from "@/utils/title"
import { analytics } from "@/services/analytics"
import router from "@/router"
import QuizQuestion from "./tasks/AlternativesTask.vue"
import { flutterStudy } from "@/utils/flutter"
import QuizNavButton from '../../components/study/LargeButton.vue';
import {
    useGetStudyLessonQuery
} from "@/graph/generated"
import { useRoute } from "vue-router"
import { VButton } from ".."
import Tasks from "./Tasks.vue"

type Page = "" | "intro" | "tasks" | "more"

const route = useRoute()
const props = defineProps<{ lessonId: string, subRoute: Page }>()

const { error, fetching, data, executeQuery, ...lessonQuery } = useGetStudyLessonQuery({ pause: props.lessonId == null, variables: { id: props.lessonId.toString() } });

const { t } = useI18n()

const { setTitle } = useTitle()

const page = ref<Page>(props.subRoute);

onMounted(async () => {
    setTitle(t("page.study"))
    analytics.page({
        id: "study",
        title: t("page.study"),
    })
    var result = await lessonQuery;
    var data = result.data.value;
    if (props.subRoute == '' && data != null) {
        var completedTasks = data.studyLesson.progress.completed;
        var totalTasks = data.studyLesson.progress.total;
        if (completedTasks == 0) {
            page.value = "intro";
        } else if (completedTasks < totalTasks) {
            page.value = "tasks";
            //router.push({ path: `./tasks`, query: route.query, params: { lessonId: props.lessonId } });
        } else {
            page.value = "more";
            router.push(`(./more`);
        }
    }
})

const reload = () => {
    executeQuery();
}

</script>