<template>
    <div class="flex bg-slate-800" v-if="!accepted">
        <div class="flex flex-col gap-4 max-w-2xl mx-auto p-4 my-4 lg:my-10">
            <h1 class="text-xl">{{ $t("cookies.title") }}</h1>
            <p class="opacity-80" v-html="$t('cookies.description')"></p>
            <SwitchGroup>
                <div class="flex flex-col lg:flex-row gap-4">
                    <div class="flex gap-2">
                        <Switch
                            class="bg-slate-700 opacity-80 cursor-not-allowed inline-flex h-6 w-11 items-center rounded-full transition"
                        >
                            <span
                                :class="
                                    true ? 'translate-x-6' : 'translate-x-1'
                                "
                                class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                            />
                        </Switch>
                        <SwitchLabel>{{ $t("cookies.necessary") }}</SwitchLabel>
                    </div>
                    <div class="flex gap-2">
                        <Switch
                            v-model="preferences"
                            :class="preferences ? 'bg-primary' : 'bg-slate-900'"
                            class="inline-flex h-6 w-11 items-center rounded-full transition"
                        >
                            <span
                                :class="
                                    preferences
                                        ? 'translate-x-6'
                                        : 'translate-x-1'
                                "
                                class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                            />
                        </Switch>
                        <SwitchLabel>{{
                            $t("cookies.preferences")
                        }}</SwitchLabel>
                    </div>
                    <div class="flex gap-2">
                        <Switch
                            v-model="statistics"
                            :class="statistics ? 'bg-primary' : 'bg-slate-900'"
                            class="inline-flex h-6 w-11 items-center rounded-full transition"
                        >
                            <span
                                :class="
                                    statistics
                                        ? 'translate-x-6'
                                        : 'translate-x-1'
                                "
                                class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                            />
                        </Switch>
                        <SwitchLabel>{{
                            $t("cookies.statistics")
                        }}</SwitchLabel>
                    </div>
                    <VButton @click="accept()">{{
                        $t("cookies.accept")
                    }}</VButton>
                </div>
            </SwitchGroup>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { useGetMeQuery } from "@/graph/generated"
import { analytics } from "@/services/analytics"
import { useCookies } from "@/services/cookies"
import { Switch, SwitchGroup, SwitchLabel } from "@headlessui/vue"
import { VButton } from "."

const { accepted, preferences, statistics } = useCookies()

const { executeQuery } = useGetMeQuery({ variables: {} })

const accept = () => {
    accepted.value = true
    analytics.initialize(
        async () =>
            (await executeQuery()).data.value?.me.analytics.anonymousId ?? null
    )
}
</script>
