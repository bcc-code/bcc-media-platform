<script lang="ts" setup>
import Loading from "@/components/support/Loading.vue";
import { useSetSupportEmailMutation } from "@/graph/generated";
import {
    Dialog,
    DialogPanel,
    DialogTitle,
    DialogDescription,
    TransitionChild,
    TransitionRoot,
  } from "@headlessui/vue"
  import { computed, ref } from "vue"
  import { useI18n } from "vue-i18n"

  const { executeMutation } = useSetSupportEmailMutation()

  const props = defineProps({show: Boolean})


  const emits = defineEmits<{
    (e: 'closeDialog'): void
  }>()

  const title = ref('');
  const content = ref('');
  // const titleErrorMsg = ref('');
  // const contentErrorMsg = ref('');

  // const titleErrorMsg = computed({
  //   get() {
  //     return title.value
  //   }
  //   setter() {

  //   }
  // })

  const isLoading = ref(false);
  //titleErrorMsg

  const errMSG = ref();

  const dispalyResult = ref();


  const submit = async (e: MouseEvent ) => {
    e.preventDefault();
    
    const isValid = await triggerValidation()
    if (!isValid) {
      // console.log("titleErrorMsg" + titleErrorMsg.value)
      // console.log("contentErrorMsg" + contentErrorMsg.value)
      console.log("isNotValid")
      return
    }
    console.log("isValid")

    isLoading.value = true;
    setInterval(() => {
    isLoading.value = false;
    }, 4000)
    errMSG.value = '';
    const result = await sendSupportEmail({
      title: title.value,
      content: content.value,
      html: '<p><p>' + title + '</p><p>' + content + '</p></p>'
    })
    if (result.error) {
      errMSG.value = result.error.message;
      console.log(result.error.message);
      return;
    }
    console.log(result);
    dispalyResult.value = result.data?.sendSupportEmail
    isLoading.value = false;
    closePanel();
  }

  const triggerValidation = async () => {
    // titleErrorMsg.value = !!title.value ? "Please Enter Title !" : ""
    // contentErrorMsg.value = !!content.value ? "Please Enter Content !" : ""
    // return (titleErrorMsg.value && contentErrorMsg.value)
    return (!!title.value && !!content.value)
  }

  const closePanel = () => {
    title.value = '';
    content.value = ''
    emits('closeDialog')
  }

  const sendSupportEmail = async(supportEmail: {
    title: string
    content: string
    html: string
  }) => {
    const result = await executeMutation({
      title: supportEmail.title,
      content: supportEmail.content,
      html: supportEmail.html
    })
    return result;
  }

</script>

<template>  
  <TransitionRoot as="template" :show="show" enter="duration-300 ease-out" enter-from="opacity-0" enter-to="opacity-100"
    leave="duration-200 ease-in" leave-from="opacity-100" leave-to="opacity-0" class="absolute top-90">
    <Dialog as="div" @close="closePanel" class="relative z-10">
      <!-- Background overlay -->
      <TransitionChild as="template" enter="transition-opacity ease-linear duration-300" enter-from="opacity-0"
        enter-to="opacity-100" leave="transition-opacity ease-linear duration-300" leave-from="opacity-100"
        leave-to="opacity-0">
        <div class="fixed inset-0 bg-black bg-opacity-30" />
      </TransitionChild>
      <!-- Dialog Panel -->
      <div class="flex min-h-full items-center justify-center p-4 text-center fixed inset-0 overflow-y-auto">
        <TransitionChild as="template" enter-from="-translate-y-full" enter-to="translate-y-0"
          enter="duration-300 ease-out" leave="duration-200 ease-in" leave-from="translate-y-0"
          leave-to="-translate-y-full" class="min-w-[500px]">
          <DialogPanel
            class="w-full max-w-md transform overflow-hidden rounded-2xl p-6 text-left align-middle shadow-xl transition-all bg-[#0D1623]">
            
            <button class="text-blue-50"> <span class="text-[#6EB0E6] font-bold rounded-full hover:bg-slate-50 hover:text-black p-2" @click="closePanel"> Cancel </span></button>
            <DialogTitle class="text-2xl text-center font-bold mb-6">
              <span>Send Support Email</span>
               </DialogTitle>
            <DialogDescription >
              <div class="relative ">
                <input type="text" id="floating_filled" class="block rounded-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-[#EBEBF599] 
                bg-[#1D2838] focus:outline-none focus:ring-0 focus:border-blue-600 peer hover:bg-[#707C8E] " placeholder=" " 
                />

                <label for="floating_filled" class="absolute text-sm text-slate-500 duration-300 transform 
                -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 text-gray-100 text-xl
                peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4"
                >Email Title</label>
              </div>

              <div>DEMO above</div>
              <div class="font-bold text-xl text-white font-Barlow overflow-y-auto overscroll-auto mt-4 mb-2">Title</div>
              <input v-model="title" id="title" type="text" style="overflow: auto ; text-overflow: ellipsis; overflow-wrap: break-word;" class="border border-#1D2838 rounded text-[#EBEBF599] text-lg bg-[#1D2838] hover:bg-[#707C8E] px-2" placeholder="Subject">
              <!-- <div v-if="!!titleErrorMsg" class="text-red">&#x26A0; {{titleErrorMsg}}</div> -->
              <section>
                <div class="">
                  <div class="text-xl font-bold mt-4 mb-2">Content</div>
                  <textarea v-model="content" name="" id="content" cols="20" rows="10" placeholder="Describe the issue you are experiencing, and what you do to make it happen."
                    class="border border-#1D2838 rounded text-[#EBEBF599] text-lg bg-[#1D2838] hover:bg-[#707C8E] px-2 rounded w-[100%]"
                  ></textarea>
                  <!-- <div v-if="!!contentErrorMsg" class="text-red">&#x26A0; {{contentErrorMsg}}</div> -->

                </div>
              </section>
                <button v-if="!isLoading" type="submit" class="flex justify-end object-right rounded-full bg-[#2ECC71] mt-2 p-2 " @click="submit">
                  <span class="text-xl font-bold">Submit</span>
                </button>
                <Loading :show="isLoading" @closeDialog="isLoading=!isLoading" > 
                  <span class="flex justify-center">Sending...</span> 
                </Loading>
              <p></p>
              <div>errMSG: {{errMSG}}</div>
              <div>dispalyResult: {{dispalyResult}}</div>
            </DialogDescription>
          </DialogPanel>
        </TransitionChild>
      </div>
    </Dialog>
  </TransitionRoot>
  

</template>