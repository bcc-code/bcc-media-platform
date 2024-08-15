<script lang="ts" setup>
import { SearchQuery } from "@/graph/generated"
import { useI18n } from "vue-i18n"
import VButton from "../VButton.vue"

const { t } = useI18n()

defineProps<{
    result: SearchQuery
}>()

defineEmits<{
    (e: "itemClick", index: number, id: string): void
}>()

const adminOn = localStorage.getItem("admin") === "true"

const open = (i: { id: string }) => {
    window.open("https://admin.brunstad.tv/admin/content/episodes/" + i.id)
}
</script>
<template>
    <div>
        <h1
            class="text-2xl font-medium mb-2"
            :class="{
                hidden: result.search.result.length === 0,
            }"
        >
            {{ t("search.episodes") }}
        </h1>
        <div class="grid lg:grid-cols-4 gap-4">
            <div
                v-for="(i, index) in result.search.result"
                :key="i.id"
                class="flex lg:hidden"
            >
                <div
                    v-if="i.__typename === 'EpisodeSearchItem'"
                    class="cursor-pointer flex"
                    @click="$emit('itemClick', index, i.id)"
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
                        <div v-if="i.showTitle && i.seasonTitle" class="flex">
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
                v-for="(i, index) in result.search.result"
                :key="i.id"
                class="lg:flex hidden mb-4"
            >
                <div
                    v-if="i.__typename === 'EpisodeSearchItem'"
                    class="cursor-pointer"
                    @click="$emit('itemClick', index, i.id)"
                >
                    <div class="relative mb-1">
                        <VButton
                            v-if="adminOn"
                            class="absolute top-2 right-2"
                            size="thin"
                            color="secondary"
                            @click="open(i)"
                        >
                            EDIT
                        </VButton>
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
                        <div v-if="i.showTitle && i.seasonTitle" class="flex">
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
