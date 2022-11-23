<template>
    <section class="overflow-x-hidden">
        <transition name="slide-fade">
            <div
                class="px-4 flex flex-col gap-8"
                v-if="data?.page.sections.items.length"
            >
                <Section
                    v-for="(section, i) in data?.page?.sections.items"
                    :section="section"
                    :index="{ last: data.page.sections.total - 1, current: i }"
                >
                </Section>
            </div>
            <div v-else-if="!fetching">
                <NotFound :title="$t('page.notFound')"></NotFound>
            </div>
            <div v-else-if="error">{{ error.message }}</div>
            <div v-else class="px-4 flex flex-col gap-16 overflow-hidden">
                <section>
                    <div class="relative">
                        <Swiper
                            style="overflow: visible"
                            :breakpoints="{
                                400: {
                                    slidesPerView: 1,
                                    spaceBetween: 4,
                                },
                                1280: {
                                    slidesPerView: 1.5,
                                    spaceBetween: 4,
                                },
                                1920: {
                                    slidesPerView: 2,
                                    spaceBetween: 4,
                                },
                            }"
                        >
                            <SwiperSlide v-for="i in 3" class="relative">
                                <div
                                    class="relative h-full cursor-pointer aspect-video overflow-hidden"
                                >
                                    <Image
                                        :src="undefined"
                                        size-source="width"
                                        :ratio="9 / 16"
                                        class="rounded rounded-xl h-full object-cover"
                                    />
                                    <div
                                        class="absolute bottom-0 w-full text-center bg-gradient-to-t from-background to-transparent pt-8"
                                    ></div>
                                </div>
                            </SwiperSlide>
                        </Swiper>
                    </div>
                </section>
                <section>
                    <div class="relative">
                        <Swiper
                            style="overflow: visible"
                            :breakpoints="{
                                0: {
                                    slidesPerView: 1.5,
                                    spaceBetween: 10,
                                    slidesPerGroup: 1,
                                },
                                1280: {
                                    slidesPerView: 4.33,
                                    spaceBetween: 10,
                                    slidesPerGroup: 4,
                                },
                                1920: {
                                    slidesPerView: 6,
                                    spaceBetween: 10,
                                    slidesPerGroup: 6,
                                },
                            }"
                        >
                            <SwiperSlide v-for="i in 6" class="relative">
                                <div class="flex flex-col cursor-pointer mt-2">
                                    <div
                                        class="relative mb-1 rounded-md w-full aspect-video overflow-hidden hover:opacity-90 transition"
                                    >
                                        <Image
                                            :src="undefined"
                                            class="rounded-md"
                                            loading="lazy"
                                            size-source="width"
                                            :ratio="9 / 16"
                                        />
                                    </div>
                                </div>
                            </SwiperSlide>
                        </Swiper>
                    </div>
                </section>
                <section>
                    <h1 class="bg-gray opacity-50 mb-4 h-5 rounded-full w-60"></h1>
                    <div class="relative">
                        <Swiper
                            style="overflow: visible"
                            :breakpoints="{
                                0: {
                                    slidesPerView: 1.5,
                                    spaceBetween: 10,
                                    slidesPerGroup: 1,
                                },
                                1280: {
                                    slidesPerView: 4.33,
                                    spaceBetween: 10,
                                    slidesPerGroup: 4,
                                },
                                1920: {
                                    slidesPerView: 6,
                                    spaceBetween: 10,
                                    slidesPerGroup: 6,
                                },
                            }"
                        >
                            <SwiperSlide v-for="i in 6" class="relative"
                                ><div
                                    class="flex flex-col rounded rounded-md mt-1 cursor-pointer hover:opacity-90 transition"
                                >
                                    <div
                                        class="relative w-full aspect-[9/16] mb-1 rounded-md overflow-hidden"
                                    >
                                        <Image
                                            :src="undefined"
                                            size-source="height"
                                            :ratio="9 / 16"
                                        />
                                    </div>
                                </div>
                            </SwiperSlide>
                        </Swiper>
                    </div>
                </section>
            </div>
        </transition>
    </section>
</template>
<script lang="ts" setup>
import { useGetPageQuery } from "@/graph/generated"
import Section from "@/components/sections/Section.vue"
import { onMounted, watch } from "vue"
import { Swiper, SwiperSlide } from "swiper/vue"
import Image from "../Image.vue"
import NotFound from "../NotFound.vue"

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

watch(
    () => data.value?.page.title,
    () => {
        const title = data.value?.page.title
        if (title) {
            emit("title", title)
        }
    }
)

onMounted(() => {
    const title = data.value?.page.title
    if (title) {
        emit("title", title)
    }
})
</script>
