<template>
    <TransitionRoot
        as="template"
        :show="show"
        enter="duration-100 ease-out"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="duration-200 ease-in"
        leave-from="opacity-100"
        leave-to="opacity-0"
        class="absolute top-90"
    >
        <Dialog as="div" @close="closePanel" class="relative z-10">
            <TransitionChild
                as="template"
                enter="transition-opacity ease-linear duration-300"
                enter-from="opacity-0"
                enter-to="opacity-100"
                leave="transition-opacity ease-linear duration-300"
                leave-from="opacity-100"
                leave-to="opacity-0"
            >
                <div class="fixed inset-0 bg-black bg-opacity-30" />
            </TransitionChild>
            <div
                class="flex min-h-full items-center justify-center lg:p-4 text-center fixed inset-0 overflow-y-auto"
            >
                <TransitionChild
                    as="template"
                    enter-from="-translate-y-full"
                    enter-to="translate-y-0"
                    enter="duration-300 ease-out"
                    leave="duration-200 ease-in"
                    leave-from="translate-y-0"
                    leave-to="-translate-y-full"
                >
                    <DialogPanel
                        class="w-full max-w-md transform overflow-hidden rounded-2xl p-4 lg:p-6 text-left align-middle shadow-xl transition-all bg-background"
                    >
                        <DialogTitle class="text-2xl text-center font-bold">
                            <span>{{ $t("support.contact") }}</span>
                        </DialogTitle>
                        <DialogDescription class="flex flex-col gap-2 mt-4">
                            <div
                                class="font-bold text-xl text-white font-Barlow overflow-y-auto overscroll-auto"
                            >
                                {{ $t("support.title") }}
                            </div>
                            <input
                                v-model="title"
                                id="title"
                                type="text"
                                maxlength="50"
                                class="ellipsis border border-white rounded text-lg px-2 py-1 border-opacity-25 bg-primary bg-opacity-10"
                                :placeholder="$t('support.subject')"
                            />
                            <!-- <div v-if="!!titleErrorMsg" class="text-red">&#x26A0; {{titleErrorMsg}}</div> -->
                            <section>
                                <div class="">
                                    <div class="text-xl font-bold mt-4 mb-2">
                                        {{ $t("support.content") }}
                                    </div>
                                    <textarea
                                        v-model="content"
                                        name=""
                                        id="content"
                                        cols="20"
                                        rows="10"
                                        :placeholder="
                                            $t('support.describeIssue')
                                        "
                                        class="w-full ellipsis border border-white rounded text-lg px-2 py-1 border-opacity-25 bg-primary bg-opacity-10"
                                    ></textarea>
                                </div>
                            </section>
                            <div ref="technicalDetails">
                                <table>
                                    <tr
                                        v-for="[key, value] in Object.entries(
                                            technicalProperties
                                        )"
                                    >
                                        <td>
                                            <strong>{{ key }}</strong>
                                        </td>
                                        <td>{{ value }}</td>
                                    </tr>
                                </table>
                            </div>
                            <div class="flex gap-2 ml-auto">
                                <VButton color="secondary" @click="closePanel">
                                    {{ $t("buttons.cancel") }}
                                </VButton>
                                <VButton
                                    :disabled="fetching"
                                    type="submit"
                                    color="green"
                                    @click="submit"
                                >
                                    {{ $t("buttons.submit") }}
                                </VButton>
                            </div>
                        </DialogDescription>
                    </DialogPanel>
                </TransitionChild>
            </div>
        </Dialog>
    </TransitionRoot>
</template>
<script lang="ts" setup>
import { VButton } from "@/components"
import { useSendSupportEmailMutation } from "@/graph/generated"
import { getRevision } from "@/services/revision"
import {
    Dialog,
    DialogPanel,
    DialogTitle,
    DialogDescription,
    TransitionChild,
    TransitionRoot,
} from "@headlessui/vue"
import { ref } from "vue"

const { fetching, executeMutation } = useSendSupportEmailMutation()

defineProps<{ show: boolean }>()

const emit = defineEmits<{
    (e: "update:show", v: boolean): void
}>()

const title = ref("")
const content = ref("")

const technicalDetails = ref(null as HTMLDivElement | null)

const technicalProperties = {
    Platform: navigator.platform,
    Version: "",
    "Window Size": window.outerWidth + " x " + window.outerHeight,
}

getRevision().then((r) => (technicalProperties.Version = r))

const submit = async () => {
    const isValid = validateForm()
    if (!isValid) {
        return
    }

    const html =
        "<div><h1>" +
        title.value +
        "</h1><p>" +
        content.value +
        "</p><br/>" +
        technicalDetails.value?.innerHTML +
        "</div>"

    await executeMutation({
        title: "BTV Web - " + title.value,
        content: content.value,
        html,
    })
    closePanel()
}

const validateForm = () => title.value && content.value

const closePanel = () => {
    title.value = ""
    content.value = ""
    emit("update:show", false)
}
</script>
