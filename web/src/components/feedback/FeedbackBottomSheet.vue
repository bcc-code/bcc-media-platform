<template>
    <swipe-modal
        v-model="_visible"
        background-color="#000000aa"
        contents-color="var(--color-background-1)"
        border-top-radius="16px"
        snap-point="70dvh"
        @close="cancel"
    >
        <template #drag-handle>
            <div class="flex items-center h-full">
                <div class="h-1 bg-label-4 rounded-full w-10 mx-auto"></div>
            </div>
        </template>
        <div class="relative text-white">
            <div
                v-show="fetching"
                class="absolute w-full h-full flex items-center justify-center"
            >
                <Loader variant="spinner" />
            </div>
            <div
                v-if="data && !fetching"
                class="w-full text-center flex flex-col"
            >
                <h2 class="mt-5 text-style-title-2 text-label-1">
                    {{ t("thankYou") }}
                </h2>
                <p class="mt-2 text-style-body-1 text-label-3">
                    {{ t("feedback.appreciated") }}
                </p>
                <VButton
                    class="flex-1 mt-6 mx-8"
                    color="secondary"
                    size="large"
                    @click="() => (_visible = false)"
                    >{{ t("buttons.close") }}</VButton
                >
            </div>
            <div v-else v-show="!fetching" class="px-4 mb-10">
                <div class="mt-8">
                    <h2 class="text-style-title-2">
                        {{ t("feedback.howEasyToUnderstand") }}
                    </h2>
                    <p class="mt-1 text-style-body-2 text-label-3">
                        {{ t("feedback.anonymousInfo") }}
                    </p>
                    <FeedbackRating
                        class="mt-2.5"
                        v-model:selected="_selected"
                    />
                </div>
                <div class="mt-6">
                    <h2 class="text-style-title-3">
                        {{ t("feedback.comment") }}
                    </h2>

                    <textarea
                        v-if="_visible"
                        v-model="comment"
                        name="comment"
                        :placeholder="t('feedback.placeholder')"
                        rows="6"
                        class="mt-2 w-full ellipsis rounded-xl text-lg pl-4 pr-6 py-3 bg-background-2 border border-transparent focus:border-tint-1 focus:outline-none placeholder:text-label-4 text-style-body-1 resize-none"
                    ></textarea>
                </div>
                <div v-if="error" class="text-red my-4 text-center">
                    {{ t("error.somethingWentWrong") }} {{ error.message }}
                </div>
                <div class="mt-4 flex">
                    <VButton
                        class="mr-4 px-8"
                        color="secondary"
                        size="large"
                        @click="cancel"
                        >Cancel</VButton
                    >
                    <VButton
                        class="flex-1"
                        size="large"
                        @click="sendFeedback"
                        :disabled="_selected == null"
                        >Send feedback</VButton
                    >
                </div>
            </div>
        </div>
    </swipe-modal>
</template>

<script lang="ts" setup>
import { computed, ref } from "vue"
import { useI18n } from "vue-i18n"
import { VButton } from ".."
import FeedbackRating from "./FeedbackRating.vue"
import swipeModal from "@takuma-ru/vue-swipe-modal"
import { useSendEpisodeFeedbackMutation } from "@/graph/generated"
import Loader from "../Loader.vue"
const { fetching, executeMutation, error, data } =
    useSendEpisodeFeedbackMutation()

const { t } = useI18n()

const props = defineProps<{
    visible: boolean
    selected: number | null
    episodeId: string
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "update:visible", val: boolean): void
    (event: "update:selected", val: number | null): void
    (e: "sent"): void
}>()

const comment = ref("")

const _selected = computed({
    get() {
        return props.selected
    },
    set(value) {
        if (value != null) {
            emit("update:selected", value)
        }
    },
})
const _visible = computed({
    get() {
        return props.visible
    },
    set(value) {
        emit("update:visible", value)
    },
})

const cancel = (e: Event) => {
    emit("update:selected", null)
    emit("update:visible", false)
    setTimeout(() => emit("update:visible", false), 10)
}
const sendFeedback = async () => {
    var result = await executeMutation({
        episodeId: props.episodeId,
        rating: _selected.value!,
        message: comment.value,
    })
    if (result.error == null) {
        emit("sent")
    }
}
</script>
<style scoped>
.modal-style {
    color: white !important;
    border-radius: 16px 16px 0 0 !important;
    background-color: var(--color-background-1) !important;
}
</style>
