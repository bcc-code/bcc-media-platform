<template>
    <section class="p-5">
        <transition name="slide-fade">
            <div
                class="flex flex-col gap-8"
                v-if="data?.page.sections.items.length"
            >
                <Section
                    v-for="section in data?.page?.sections.items"
                    :section="section"
                >
                </Section>
            </div>
            <div v-else-if="!fetching">Uh oh. Missing content</div>
            <div v-else-if="error">{{ error.message }}</div>
            <div v-else class="flex flex-col gap-4 overflow-hidden">
                <div class="flex overflow-hidden gap-4">
                    <div
                        class="space-y-5 rounded-2xl bg-white/5 p-4"
                        v-for="i in 6"
                    >
                        <div
                            class="w-64 aspect-video rounded-lg bg-rose-100/10"
                        ></div>
                        <div class="h-3 w-3/5 rounded-lg bg-rose-100/10"></div>
                        <div class="h-3 w-2/5 rounded-lg bg-rose-100/20"></div>
                    </div>
                </div>

                <div class="flex overflow-hidden gap-4">
                    <div
                        class="space-y-5 rounded-2xl bg-white/5 p-4"
                        v-for="i in 6"
                    >
                        <div
                            class="w-48 aspect-[9/16] rounded-lg bg-rose-100/10"
                        ></div>
                        <div class="h-3 w-3/5 rounded-lg bg-rose-100/10"></div>
                        <div class="h-3 w-2/5 rounded-lg bg-rose-100/20"></div>
                    </div>
                </div>

                <div class="flex overflow-hidden gap-4">
                    <div
                        class="space-y-5 rounded-2xl bg-white/5 p-4"
                        v-for="i in 4"
                    >
                        <div
                            class="h-64 aspect-video rounded-lg bg-rose-100/10"
                        ></div>
                        <div class="space-y-3">
                            <div
                                class="h-3 w-2/5 rounded-lg bg-rose-100/20"
                            ></div>
                            <div
                                class="h-3 w-3/5 rounded-lg bg-rose-100/10"
                            ></div>
                            <div
                                class="h-3 w-4/5 rounded-lg bg-rose-100/20"
                            ></div>
                        </div>
                    </div>
                </div>
            </div>
        </transition>
    </section>
</template>
<script lang="ts" setup>
import { useGetPageQuery } from "@/graph/generated"
import Section from "@/components/sections/Section.vue"
import { onMounted, watch } from "vue";

const props = defineProps<{
    pageId: string
}>()

const emit = defineEmits<{
    (e: "title", v: string): void
}>()

const { data, error, fetching } = useGetPageQuery({
    variables: {
        code: props.pageId,
    },
})

watch(() => data.value?.page.title, () => {
    const title = data.value?.page.title
    if (title) {
        emit("title", title)
    }
})

onMounted(() => {
    const title = data.value?.page.title
    if (title) {
        emit("title", title)
    }
})
</script>
