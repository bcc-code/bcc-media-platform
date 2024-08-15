<script lang="ts">
// use normal <script> to declare options
export default {
    inheritAttrs: false,
}
</script>
<script lang="ts" setup>
import { useI18n } from 'vue-i18n'
import {
    Dialog,
    DialogPanel,
    TransitionRoot,
    TransitionChild,
} from '@headlessui/vue'

const { t } = useI18n()

const props = defineProps<{
    visible: boolean
}>()
const emit = defineEmits<{
    (event: 'update:visible', val: boolean): void
}>()

const cancel = () => {
    emit('update:visible', false)
}
</script>

<template>
    <TransitionRoot :show="visible" as="template">
        <Dialog as="div" class="relative z-10" @close="() => cancel()">
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
                        v-bind="$attrs"
                        class="bg-background-2 w-full max-w-sm rounded-xl"
                    >
                        <slot></slot>
                    </DialogPanel>
                </TransitionChild>
            </div>
        </Dialog>
    </TransitionRoot>
</template>
