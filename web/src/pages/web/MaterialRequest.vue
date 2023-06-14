<script lang="ts" setup>
import { useAuth0 } from "@auth0/auth0-vue"
import { reactive } from "vue"
import {
    OptionSelector,
    TextInput,
    TextArea,
    DateSelector,
} from "@/components/web"

const { user, isLoading, isAuthenticated, loginWithRedirect } = useAuth0()

while (isLoading.value) {
    await new Promise((r) => setTimeout(r, 500))
}

if (!isAuthenticated.value) {
    loginWithRedirect()
}

const form = reactive({
    name: user.value?.name,
    role: "",
    email: user.value?.email,
    material: "",
    materialUrl: "",
    materialUsageHow: "",
    materialUsageWhere: "",
    materialUsageWhen: "",
})

const clear = () => {
    form.name = user.value?.name
    form.email = user.value.email
    form.role = ""
    form.material = ""
    form.materialUrl = ""
    form.materialUsageHow = ""
    form.materialUsageWhen = ""
    form.materialUsageWhere = ""
}
</script>

<template>
    <section class="flex p-8">
        <div class="mx-auto max-w-4xl p-6 rounded bg-background-2 w-full">
            <h1 class="text-2xl font-bold text-center">Material request</h1>
            <div class="flex flex-col md:grid grid-cols-2 gap-8">
                <TextInput v-model="form.name">Fullt navn</TextInput>
                <TextInput v-model="form.email">E-post</TextInput>
                <OptionSelector
                    v-model="form.role"
                    :options="[
                        'Redaktør',
                        'Regissør',
                        'Produsent',
                        'Mediegruppeansvarlig',
                    ]"
                    :allow-any="true"
                    >Rolle</OptionSelector
                >
                <TextInput class="col-span-2" v-model="form.material"
                    >Materiale</TextInput
                >
                <TextInput class="col-span-2" v-model="form.materialUrl"
                    >URL til materialet (hvis aktuelt)</TextInput
                >
                <TextArea class="col-span-2" v-model="form.materialUsageHow"
                    >Hvordan skal materialet brukes?</TextArea
                >
                <OptionSelector
                    v-model="form.materialUsageWhere"
                    :options="['Stevne/Camp', 'Lokalt']"
                    :allow-any="true"
                    >Hvor skal materialet brukes?</OptionSelector
                >
                <DateSelector v-model="form.materialUsageWhen"
                    >Når skal materialet brukes?</DateSelector
                >
                <div class="flex col-span-2">
                    <button
                        class="ml-auto bg-slate-700 rounded p-2 px-8 hover:-translate-y-0.5 transition"
                        @click="clear"
                    >
                        Clear
                    </button>
                    <button
                        class="ml-4 bg-green-500 rounded p-2 px-8 hover:-translate-y-0.5 transition"
                    >
                        Send
                    </button>
                </div>
            </div>
        </div>
    </section>
</template>
