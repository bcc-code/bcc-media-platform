<script lang="ts" setup>
import { useAuth0 } from "@auth0/auth0-vue"
import { computed, reactive, ref } from "vue"
import Modal from "@/components/web/ConfirmSendModal.vue"
import {
    OptionSelector,
    TextInput,
    TextArea,
    DateSelector,
} from "@/components/web"
import { useSendSupportEmailMutation } from "@/graph/generated"

const { user, isLoading, isAuthenticated, loginWithRedirect } = useAuth0()

while (isLoading.value) {
    await new Promise((r) => setTimeout(r, 500))
}

if (!isAuthenticated.value) {
    loginWithRedirect()
}

const form = reactive({
    name: user.value?.name ?? "",
    role: "",
    email: user.value?.email ?? "",
    material: "",
    materialUrl: "",
    materialUsageHow: "",
    materialUsageWhere: "",
    materialUsageWhen: "",
})

const clear = () => {
    form.name = user.value?.name ?? ""
    form.email = user.value?.email ?? ""
    form.role = ""
    form.material = ""
    form.materialUrl = ""
    form.materialUsageHow = ""
    form.materialUsageWhen = ""
    form.materialUsageWhere = ""
}

const { executeMutation } = useSendSupportEmailMutation()

const html = computed(() => {
    return `
    <table>
        <thead>
            <th class="text-left">Question</th>
            <th class="text-left">Answer</th>
        </thead>
        <tbody>
            <tr>
                <td>Name</td>
                <td>${form.name}</td>
            </tr>
            <tr>
                <td>Email</td>
                <td>${form.email}</td>
            </tr>
            <tr>
                <td>Role</td>
                <td>${form.role}</td>
            </tr>
            <tr>
                <td>What</td>
                <td>${form.material}</td>
            </tr>
            <tr>
                <td>URL</td>
                <td>${form.materialUrl}</td>
            </tr>
            <tr>
                <td>How</td>
                <td>${form.materialUsageHow}</td>
            </tr>
            <tr>
                <td>Where</td>
                <td>${form.materialUsageWhere}</td>
            </tr>
            <tr>
                <td>When</td>
                <td>${form.materialUsageWhen}</td>
            </tr>
        </tbody>
    </table>
    `
})

const showSend = ref(false)

const send = async () => {
    await executeMutation({
        title: "Material request",
        content: "",
        html: html.value,
    })
    showSend.value = false
}
</script>

<template>
    <section class="flex p-8 h-screen" v-if="isAuthenticated">
        <div class="max-w-4xl m-auto w-full flex flex-col gap-8">
            <div class="rounded bg-background-2 p-6">
                <h1 class="text-2xl font-bold text-center">Material request</h1>
                <div class="flex flex-col md:grid grid-cols-2 gap-8">
                    <TextInput v-model="form.name">{{
                        $t("requests.fullName")
                    }}</TextInput>
                    <TextInput v-model="form.email">{{
                        $t("requests.email")
                    }}</TextInput>
                    <OptionSelector
                        v-model="form.role"
                        :options="[
                            $t('requests.editor'),
                            $t('requests.director'),
                            $t('requests.producer'),
                            $t('requests.mediaResponsible'),
                        ]"
                        :allow-any="true"
                        >{{ $t("requests.role") }}</OptionSelector
                    >
                    <TextInput class="col-span-2" v-model="form.material">{{
                        $t("requests.material")
                    }}</TextInput>
                    <TextInput class="col-span-2" v-model="form.materialUrl">{{
                        $t("requests.materialUrl")
                    }}</TextInput>
                    <div class="col-span-2">
                        <TextArea v-model="form.materialUsageHow">{{
                            $t("requests.materialUsageHow")
                        }}</TextArea>
                        <small class="text-gray">{{
                            $t("requests.materialUsageHowDescription")
                        }}</small>
                    </div>
                    <OptionSelector
                        v-model="form.materialUsageWhere"
                        :options="[
                            $t('requests.eventCamp'),
                            $t('requests.local'),
                        ]"
                        :allow-any="true"
                        >{{ $t("requests.materialUsageWhere") }}</OptionSelector
                    >
                    <DateSelector v-model="form.materialUsageWhen">{{
                        $t("requests.materialUsageWhen")
                    }}</DateSelector>
                    <div class="flex col-span-2">
                        <button
                            class="ml-auto bg-slate-700 rounded p-2 px-8 hover:-translate-y-0.5 transition"
                            @click="clear"
                        >
                            {{ $t("requests.clear") }}
                        </button>
                        <button
                            class="ml-4 bg-green-500 rounded p-2 px-8 hover:-translate-y-0.5 transition"
                            @click="showSend = true"
                        >
                            {{ $t("requests.send") }}
                        </button>
                    </div>
                </div>
            </div>
            <div class="rounded bg-background-2 p-6">
                <div v-html="html" class="text-gray"></div>
            </div>
        </div>
    </section>
    <Modal v-model:open="showSend" @confirm="send">
        <template #preview>
            <div v-html="html" class="text-gray"></div>
        </template>
    </Modal>
</template>
