<script lang="ts" setup>
import {
    Dialog,
    DialogPanel,
    DialogTitle,
    DialogDescription,
    TransitionChild,
    TransitionRoot,
  } from "@headlessui/vue"
import { ref } from "vue"

const props = defineProps({
  isLoading: Boolean
})

// const emit = defineEmits<{
//   (e: "closeDialog"): void
// }>()



</script>

<template>
  <TransitionRoot as="template" :show="isLoading" enter="duration-300 ease-out" enter-from="opacity-0" enter-to="opacity-100"
    leave="duration-200 ease-in" leave-from="opacity-100" leave-to="opacity-0" class="absolute top-90">
    <Dialog as="div" class="relative z-10" @close="">
      <TransitionChild as="template" enter="transition-opacity ease-linear duration-300" enter-from="opacity-0"
        enter-to="opacity-100" leave="transition-opacity ease-linear duration-300" leave-from="opacity-100"
        leave-to="opacity-0">
        <div class="fixed inset-0 bg-black bg-opacity-30" />
      </TransitionChild>
      <div class="flex min-h-full items-center justify-center p-4 text-center fixed inset-0 overflow-y-auto">
        <TransitionChild as="template" enter-from="-translate-y-full" enter-to="translate-y-0"
          enter="duration-300 ease-out" leave="duration-200 ease-in" leave-from="translate-y-0"
          leave-to="-translate-y-full" class="min-w-[100px]">
          <DialogPanel
            class="w-[100px] max-w-md transform overflow-hidden rounded-2xl p-6 text-left align-middle shadow-xl transition-all bg-[#0D1623]">
            <DialogDescription class="grid grid-cols-1 gap-4 ">
              <div role="status" class="flex justify-center">
                <svg aria-hidden="true" class="mr-2 w-8 h-8 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600" viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z" fill="currentColor"/>
                    <path d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z" fill="currentFill"/>
                </svg>
              </div>
              <slot class="flex justify-center">Loading</slot>
            </DialogDescription>
          </DialogPanel>
        </TransitionChild>
      </div>
    </Dialog>
  </TransitionRoot>

</template>