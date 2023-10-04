<script lang="ts" setup>
import { useGetFaqQuery } from "@/graph/generated"
import Loader from "../Loader.vue"
import {
    Dialog,
    DialogDescription,
    DialogPanel,
    DialogTitle,
    TransitionChild,
    TransitionRoot,
} from "@headlessui/vue"
import { VButton } from ".."

defineProps<{
    show: boolean
}>()

defineEmits<{
    (e: "update:show", v: boolean): void
}>()

const { data, fetching } = useGetFaqQuery()
</script>
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
        <Dialog
            as="div"
            @close="$emit('update:show', false)"
            class="relative z-10"
        >
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
                        class="w-full max-w-lg max-h-screen overflow-y-auto transform overflow-hidden rounded-2xl p-4 lg:p-6 text-left align-middle shadow-xl transition-all bg-background"
                    >
                        <DialogTitle class="flex text-2xl font-bold">
                            <div>{{ $t("support.faq") }}</div>
                            <div class="ml-auto">
                                <VButton @click="$emit('update:show', false)">{{
                                    $t("buttons.close")
                                }}</VButton>
                            </div>
                        </DialogTitle>
                        <DialogDescription class="flex flex-col gap-2 mt-4">
                            <section class="flex flex-col gap-8">
                                <div v-if="fetching">
                                    <Loader />
                                </div>
                                <div v-for="c in data?.faq.categories?.items">
                                    <h3 class="text-lg font-bold">
                                        {{ c.title }}
                                    </h3>
                                    <div class="flex flex-col gap-4">
                                        <div v-for="q in c.questions?.items">
                                            <h4>
                                                {{ q.question }}
                                            </h4>
                                            <p
                                                class="text-sm text-gray prose-p"
                                            >
                                                {{ q.answer }}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <VButton @click="$emit('update:show', false)">{{
                                    $t("buttons.close")
                                }}</VButton>
                            </section>
                        </DialogDescription>
                    </DialogPanel>
                </TransitionChild>
            </div>
        </Dialog>
    </TransitionRoot>
</template>
