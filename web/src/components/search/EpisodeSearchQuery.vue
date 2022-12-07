<template>
    <div>
        <h1
            class="text-2xl font-medium mb-2"
            :class="{
                hidden: result.length === 0,
            }"
        >
            {{ t("search.episodes") }}
        </h1>
        <div class="grid lg:grid-cols-4 gap-4">
            <div
                class="flex lg:hidden"
                v-for="(i, index) in data?.search.result"
                :key="i.id"
            >
                <div
                    v-if="i.__typename === 'EpisodeSearchItem'"
                    class="cursor-pointer flex"
                    @click="$emit('itemClick', index, i)"
                >
                    <div class="relative mb-1 w-1/2 pr-2 py-2">
                        <img
                            :id="i.id"
                            :src="
                                i.image +
                                `?h=${225}&w=${450}&fit=crop&crop=faces`
                            "
                            loading="lazy"
                            class="rounded-md top-0 w-full object-cover aspect-video"
                        />
                    </div>
                    <div class="mt-1 w-1/2 flex flex-col">
                        <div class="flex" v-if="i.showTitle && i.seasonTitle">
                            <h3 class="text-sm text-primary mr-1 truncate">
                                {{ i.showTitle }}
                            </h3>
                            <p class="text-gray text-sm ml-auto truncate">
                                {{ i.seasonTitle }}
                            </p>
                        </div>
                        <h1
                            :class="i.title.length > 20 ? 'text-md' : 'text-lg'"
                        >
                            {{ i.title }}
                        </h1>
                    </div>
                </div>
            </div>
            <div
                class="lg:flex hidden mb-4"
                v-for="(i, index) in data?.search.result"
                :key="i.id"
            >
                <div
                    v-if="i.__typename === 'EpisodeSearchItem'"
                    class="cursor-pointer"
                    @click="$emit('itemClick', index, i)"
                >
                    <div class="relative mb-1">
                        <img
                            :id="i.id"
                            :src="
                                i.image +
                                `?h=${225}&w=${450}&fit=crop&crop=faces`
                            "
                            loading="lazy"
                            class="rounded-md top-0 w-full object-cover aspect-video"
                        />
                    </div>
                    <div class="mt-1 flex flex-col">
                        <div class="flex" v-if="i.showTitle && i.seasonTitle">
                            <h3 class="text-sm text-primary">
                                {{ i.showTitle }}
                            </h3>
                            <!-- <p class="text-gray text-sm ml-1">
                                {{ i.seasonTitle }}
                            </p> -->
                        </div>
                        <h1 class="text-lg">{{ i.title }}</h1>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { SearchQuery, useSearchQuery } from "@/graph/generated"
import { computed, ref, watch } from "vue"
import { useI18n } from "vue-i18n"

const { t } = useI18n()

const props = defineProps<{
    query: string
    pause: boolean
}>()

defineEmits<{
    (
        e: "itemClick",
        index: number,
        episode: SearchQuery["search"]["result"][0] & {
            __typename: "EpisodeSearchItem"
        }
    ): void
}>()

const queryString = ref(props.query)

const { data, pause, resume } = useSearchQuery({
    pause: props.pause,
    variables: {
        query: queryString,
        type: "episode",
    },
})

watch(
    () => props.query,
    () => {
        queryString.value = props.query
    }
)

watch(
    () => props.pause,
    () => {
        if (props.pause) {
            pause()
        } else {
            resume()
        }
    }
)

const result = computed(() => {
    return data.value?.search.result ?? []
})
</script>
