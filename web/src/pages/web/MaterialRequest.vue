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
import { useGetMeQuery, useSendSupportEmailMutation } from "@/graph/generated"
import LanguageSelector from "@/components/LanguageSelector.vue"

const { user, isAuthenticated, loginWithRedirect, logout } = useAuth0()

const { data, fetching } = useGetMeQuery()

while (fetching.value) {
    await new Promise((r) => setTimeout(r, 500))
}

if (!isAuthenticated.value) {
    // localStorage.setItem("redirect", "/web/material-request")
    loginWithRedirect({
        appState: {
            target: "/web/material-request",
        },
    })
}

const form = reactive({
    name: user.value?.name ?? "",
    role: "",
    material: "",
    materialUsageHow: "",
    materialUsageWhere: "",
    materialUsageWhen: "",
})

const clear = () => {
    form.name = user.value?.name ?? ""
    form.role = ""
    form.material = ""
    form.materialUsageHow = ""
    form.materialUsageWhen = ""
    form.materialUsageWhere = ""
}

const canSend = computed(() => {
    return (
        !!form.material &&
        !!form.materialUsageHow &&
        !!form.role &&
        !!form.materialUsageWhen &&
        !!form.materialUsageWhere &&
        agendaConfirmed.value
    )
})
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
                <td>Role</td>
                <td>${form.role}</td>
            </tr>
            <tr>
                <td>What</td>
                <td>${form.material}</td>
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

const showConfirmation = ref(false)

const send = async () => {
    await executeMutation({
        title: "Material request",
        content: "",
        html: html.value,
    })
    showSend.value = false
    showConfirmation.value = true
}

const agendaConfirmed = ref(false)
</script>

<template>
    <section
        class="flex flex-col h-screen w-screen bg-bcc-1 font-archivo"
        v-if="isAuthenticated && data?.me.bccMember"
    >
        <div class="max-w-4xl m-auto w-full flex flex-col gap-8">
            <div class="rounded bg-bcc p-6">
                <div class="text-center mb-4 flex flex-col">
                    <h1 class="text-2xl font-bold mb-2">
                        {{ $t("requests.title") }}
                    </h1>
                    <small class="text-sm">{{
                        $t("requests.description")
                    }}</small>
                    <LanguageSelector class="ml-auto"></LanguageSelector>
                </div>
                <div class="flex flex-col md:grid grid-cols-2 gap-8">
                    <TextInput v-model="form.name" readonly>{{
                        $t("requests.name")
                    }}</TextInput>
                    <OptionSelector
                        v-model="form.role"
                        allow-any
                        required
                        :options="[
                            $t('requests.editor'),
                            $t('requests.director'),
                            $t('requests.producer'),
                            $t('requests.mediaResponsible'),
                        ]"
                        >{{ $t("requests.role")
                        }}<span class="ml-1 text-red">*</span></OptionSelector
                    >
                    <TextArea
                        class="col-span-2"
                        v-model="form.material"
                        required
                        >{{ $t("requests.what") }}</TextArea
                    >
                    <div class="col-span-2">
                        <TextArea v-model="form.materialUsageHow" required>{{
                            $t("requests.how")
                        }}</TextArea>
                    </div>
                    <OptionSelector
                        v-model="form.materialUsageWhere"
                        required
                        allow-any
                        :options="[
                            $t('requests.eventCamp'),
                            $t('requests.local'),
                        ]"
                        >{{ $t("requests.where")
                        }}<span class="ml-1 text-red">*</span></OptionSelector
                    >
                    <DateSelector v-model="form.materialUsageWhen" required
                        >{{ $t("requests.when")
                        }}<span class="ml-1 text-red">*</span></DateSelector
                    >
                    <div class="flex col-span-2">
                        <div class="ml-auto block md:flex gap-4">
                            <div
                                @click="agendaConfirmed = !agendaConfirmed"
                                class="flex mb-1 gap-1 rounded-xl px-2 py-1 bg-bcc-2 my-auto hover:-translate-y-0.5 transition"
                            >
                                <input
                                    name="agenda"
                                    type="checkbox"
                                    class="cursor-pointer"
                                    v-model="agendaConfirmed"
                                />
                                <label
                                    for="agenda"
                                    class="my-auto cursor-pointer"
                                    >{{ $t("requests.confirmAgenda") }}</label
                                >
                            </div>
                            <button
                                class="bg-bcc-1 rounded p-2 px-8 hover:-translate-y-0.5 transition"
                                @click="clear"
                            >
                                {{ $t("requests.clear") }}
                            </button>
                            <button
                                class="bg-bcc-3 text-black rounded p-2 px-8 hover:-translate-y-0.5 transition"
                                :class="{
                                    'opacity-50 cursor-not-allowed': !canSend,
                                }"
                                :disabled="!canSend"
                                @click="showSend = true"
                            >
                                {{ $t("requests.send") }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- <Footer />
        <Cookies /> -->
    </section>
    <Modal v-model:open="showSend" class="font-archivo" @confirm="send">
        <template #description>
            <div v-html="html" class="text-gray"></div>
        </template>
    </Modal>
    <Modal
        v-model:open="showConfirmation"
        class="font-archivo"
        @confirm="showConfirmation = false"
    >
        <template #title>
            {{ $t("requests.receitTitle") }}
        </template>
        <template #description>
            <p>{{ $t("requests.receitDescription") }}</p>
        </template>
        <template #actions>
            <button
                class="inline-flex justify-center rounded-md border border-transparent text-black bg-bcc-3 px-4 py-2 text-sm font-medium"
                @click="showConfirmation = false"
            >
                {{ $t("buttons.close") }}
            </button>
        </template>
    </Modal>
</template>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Archivo&display=swap");
</style>
