<template>
    <TransitionRoot :show="visible" as="template">
        <Dialog @close="() => cancel()" as="div" class="relative z-10">
            <TransitionChild
                as="template"
                enter="duration-300 ease-out"
                enter-from="opacity-0"
                enter-to="opacity-100"
                leave="duration-200 ease-in"
                leave-from="opacity-100"
                leave-to="opacity-0"
            >
                <div class="fixed inset-0 bg-black/30" aria-hidden="true"></div>
            </TransitionChild>
            <!-- Full-screen container to center the panel -->
            <div class="fixed inset-0 flex items-center justify-center p-4">
                <!-- The actual dialog panel -->
                <TransitionChild
                    as="template"
                    enter="duration-100 ease-out"
                    enter-from="opacity-0 scale-95"
                    enter-to="opacity-100 scale-100"
                    leave="duration-100 ease-in"
                    leave-from="opacity-100 scale-100"
                    leave-to="opacity-0 scale-95"
                >
                    <DialogPanel
                        class="bg-background-1 w-full max-w-sm rounded-xl"
                    >
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
                                @click="() => emit('update:visible', false)"
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
                                    v-model="comment"
                                    name="comment"
                                    :placeholder="t('feedback.placeholder')"
                                    rows="6"
                                    class="mt-2 w-full ellipsis rounded-xl text-lg pl-4 pr-6 py-3 bg-background-2 border border-transparent focus:border-tint-1 focus:outline-none placeholder:text-label-4 feedback-comment resize-none"
                                ></textarea>
                            </div>
                            <div v-if="error" class="text-red my-4 text-center">
                                {{ t("error.somethingWentWrong") }}
                                {{ error.message }}
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
                                    >Send feedback</VButton
                                >
                            </div>
                        </div>
                    </DialogPanel>
                </TransitionChild>
            </div>
        </Dialog>
    </TransitionRoot>
</template>

<script lang="ts" setup>
import { computed, ref } from "vue"
import { useI18n } from "vue-i18n"
import { VButton } from ".."
import FeedbackBottomSheet from "./FeedbackModal.vue"
import FeedbackRating from "./FeedbackRating.vue"
import swipeModal from "@takuma-ru/vue-swipe-modal"
import { useSendEpisodeFeedbackMutation } from "@/graph/generated"
import { exec } from "child_process"
import Loader from "../Loader.vue"
import { flutter } from "@/utils/flutter"
import {
    Dialog,
    DialogPanel,
    TransitionRoot,
    TransitionChild,
} from "@headlessui/vue"

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

const cancel = () => {
    emit("update:selected", null)
    emit("update:visible", false)
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
.feedback-comment::placeholder {
    /* body1 */
    font-size: 1.188rem;
    font-family: "Barlow";
    font-weight: 400;
    font-style: normal;
    line-height: 24px;
    text-decoration: none;
    text-transform: none;
}

:root {
    --contents-height: 100vh;
}
</style>
