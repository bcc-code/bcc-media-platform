<script lang="ts" setup>
import {
    SubscriptionTopic,
    useSubscribeToTopicMutation,
    useUnsubscribeToTopicMutation,
    useGetSubscriptionsQuery,
} from "@/graph/generated"
import VButton from "../VButton.vue"
import { computed, watch, ref } from "vue"
import Loader from "../Loader.vue"

const props = defineProps<{
    topic: SubscriptionTopic
}>()

const subMutation = useSubscribeToTopicMutation()
const unsubMutation = useUnsubscribeToTopicMutation()

const query = useGetSubscriptionsQuery()
const subscribed = ref<boolean | undefined>(false)
watch(query.data, () => {
    subscribed.value = query.data?.value?.subscriptions.some(
        (subscription) => subscription === props.topic
    )
})

const loading = computed(() => {
    return (
        query.fetching.value ||
        subMutation.fetching.value ||
        unsubMutation.fetching.value
    )
})
const error = ref<string | undefined>(undefined)
watch(query.error, () => {
    error.value = query.error.value?.message
})
watch(subMutation.error, () => {
    error.value = subMutation.error.value?.message
})
watch(unsubMutation.error, () => {
    error.value = unsubMutation.error.value?.message
})

const handleClick = async () => {
    error.value = undefined
    if (subscribed.value) {
        const result = await unsubMutation.executeMutation({
            topic: props.topic,
        })
        const data = result.data?.unsubscribe
        if (data) {
            subscribed.value = false
        }
    } else {
        const result = await subMutation.executeMutation({ topic: props.topic })
        const data = result.data?.subscribe
        if (data) {
            subscribed.value = true
        }
    }
}

defineOptions({
    inheritAttrs: false,
})
</script>

<template>
    <VButton
        v-bind="$attrs"
        class="relative transition-all duration-500 ease-out-expo"
        :color="error ? 'red' : subscribed ? 'secondary' : 'default'"
        @click="handleClick"
    >
        <div
            v-if="loading"
            class="absolute top-0 left-0 w-full h-full flex items-center justify-center"
        >
            <Loader variant="spinner" class="text-white h-[1.5rem]" />
        </div>
        <div
            class="flex items-center justify-center"
            :class="{ 'opacity-0': loading }"
        >
            {{
                subscribed
                    ? $t("subscriptions.unsubscribe")
                    : $t("subscriptions.subscribe")
            }}
        </div>
    </VButton>
    <div class="mt-1 text-center" v-if="error">
        {{ $t("error.somethingWentWrong") }} <br />Error: {{ error }}
    </div>
</template>
