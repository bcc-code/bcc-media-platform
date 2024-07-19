<template>
    <div class="flex flex-col gap-16 overflow-hidden h-full">
        <section>
            <div class="relative">
                <Swiper
                    style="overflow: visible"
                    :breakpoints="{
                        400: {
                            slidesPerView: 2,
                            spaceBetween: 6,
                        },
                        1280: {
                            slidesPerView: 2,
                            spaceBetween: 6,
                        },
                        1920: {
                            slidesPerView: 3,
                            spaceBetween: 6,
                        },
                    }"
                >
                    <SwiperSlide v-for="i in 3" class="relative">
                        <div
                            class="relative h-full cursor-pointer aspect-video w-full overflow-hidden max-h-[60vh]"
                        >
                            <Image
                                :src="undefined"
                                size-source="width"
                                :ratio="9 / 16"
                                class="lg:hidden rounded-xl h-full object-cover"
                            />
                            <Image
                                :src="undefined"
                                size-source="width"
                                :ratio="9 / 16"
                                class="hidden lg:block rounded-xl h-full object-cover"
                            />
                            <div
                                class="absolute bottom-0 w-full text-center bg-gradient-to-t from-background-2 to-transparent pt-8"
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
            <h1
                class="bg-background-2 opacity-50 mb-4 h-5 rounded-full w-60"
            ></h1>
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
                            class="flex flex-col rounded-md mt-1 cursor-pointer hover:opacity-90 transition"
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
</template>
<script lang="ts" setup>
import { Swiper, SwiperSlide } from "swiper/vue"
import Image from "../Image.vue"
</script>
