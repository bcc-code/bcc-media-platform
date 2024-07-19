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

const { data, fetching } = useGetFaqQuery({ variables: {} })
</script>
<template>
    <TransitionRoot as="template" :show="show">
        <Dialog
            as="div"
            @close="$emit('update:show', false)"
            class="relative z-10"
        >
            <TransitionChild
                as="template"
                enter="transition-opacity ease-out-expo duration-500"
                leave="transition-opacity ease-out-expo duration-500"
                enter-from="opacity-0"
                leave-to="opacity-0"
                leave-from="opacity-100"
                enter-to="opacity-100"
            >
                <div class="fixed inset-0 bg-slate-800/50 bg-opacity-30" />
            </TransitionChild>
            <div
                class="flex min-h-full items-center justify-center lg:p-4 text-center fixed inset-0 overflow-y-auto"
            >
                <TransitionChild
                    as="template"
                    enter-from="scale-95 "
                    enter-to="scale-100"
                    leave-from="scale-100"
                    leave-to="scale-95 opacity-0"
                >
                    <DialogPanel
                        class="duration-500 ease-out-expo w-full max-w-lg max-h-screen overflow-y-auto overflow-hidden rounded-2xl p-4 lg:p-6 text-left align-middle shadow-xl transition-all bg-background"
                    >
                        <DialogTitle class="flex text-2xl font-bold">
                            <div>{{ $t("support.faq") }}</div>
                            <div class="ml-auto">
                                <VButton
                                    @click="$emit('update:show', false)"
                                    size="thin"
                                    >{{ $t("buttons.close") }}</VButton
                                >
                            </div>
                        </DialogTitle>
                        <DialogDescription class="flex flex-col gap-2 mt-4">
                            <section class="flex flex-col gap-8">
                                <div v-if="fetching">
                                    <Loader />
                                </div>
                                <div v-for="c in data?.faq.categories?.items">
                                    <h3 class="text-style-title-2 mb-1">
                                        {{ c.title }}
                                    </h3>
                                    <div class="flex flex-col gap-4">
                                        <div v-for="q in c.questions?.items">
                                            <h4 class="text-style-body-3 mb-1">
                                                {{ q.question }}
                                            </h4>
                                            <p
                                                class="text-style-body-3 text-label-3"
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
