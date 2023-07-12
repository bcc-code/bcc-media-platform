<template>
    <TransitionRoot appear :show="open" as="template">
        <Dialog as="div" @close="closeModal" class="relative z-10">
            <TransitionChild
                as="template"
                enter="duration-300 ease-out"
                enter-from="opacity-0"
                enter-to="opacity-100"
                leave="duration-200 ease-in"
                leave-from="opacity-100"
                leave-to="opacity-0"
            >
                <div class="fixed inset-0 bg-black bg-opacity-25" />
            </TransitionChild>

            <div class="fixed inset-0 overflow-y-auto">
                <div
                    class="flex min-h-full items-center justify-center p-4 text-center"
                >
                    <TransitionChild
                        as="template"
                        enter="duration-300 ease-out"
                        enter-from="opacity-0 scale-95"
                        enter-to="opacity-100 scale-100"
                        leave="duration-200 ease-in"
                        leave-from="opacity-100 scale-100"
                        leave-to="opacity-0 scale-95"
                    >
                        <DialogPanel
                            class="w-full max-w-md transform overflow-hidden rounded-2xl bg-bcc p-6 text-left align-middle shadow-xl transition-all"
                        >
                            <DialogTitle
                                as="h3"
                                class="text-lg font-medium leading-6 text-gray-900"
                            >
                                <slot name="title">
                                    {{ $t("requests.confirmSend") }}
                                </slot>
                            </DialogTitle>
                            <div class="mt-2">
                                <p class="text-sm">
                                    <slot name="description"></slot>
                                </p>
                            </div>

                            <div class="mt-4 flex gap-4">
                                <slot name="actions">
                                    <button
                                        type="button"
                                        class="inline-flex justify-center rounded-full border border-transparent bg-bcc-1 px-4 py-2 text-sm font-medium"
                                        @click="closeModal"
                                    >
                                        {{ $t("buttons.cancel") }}
                                    </button>
                                    <button
                                        type="button"
                                        class="inline-flex justify-center rounded-full border border-transparent bg-bcc-3 text-black px-4 py-2 text-sm font-medium"
                                        @click="$emit('confirm')"
                                    >
                                        {{ $t("requests.send") }}
                                    </button>
                                </slot>
                            </div>
                        </DialogPanel>
                    </TransitionChild>
                </div>
            </div>
        </Dialog>
    </TransitionRoot>
</template>

<script setup lang="ts">
import { ref } from "vue"
import {
    TransitionRoot,
    TransitionChild,
    Dialog,
    DialogPanel,
    DialogTitle,
} from "@headlessui/vue"

defineProps<{
    open: boolean
}>()

const emit = defineEmits<{
    (e: "update:open", v: boolean): void
    (e: "confirm"): void
    (e: "close"): void
}>()

function closeModal() {
    emit("update:open", false)
    emit("close")
}
function openModal() {
    emit("update:open", true)
}
</script>
