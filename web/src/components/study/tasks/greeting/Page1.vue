<template>
    <div class="h-full w-full point-events-none flex flex-col items-center">
        <div class="mt-24 px-16 text-right flex-1 justify-center flex flex-col">
            <p class="font-bold text-2xl" data-swiper-parallax-y="-500">
                <span v-if="displayName">Kjære {{ displayName }}</span>
                <span v-else>&nbsp;</span>
            </p>
            <p class="mt-5 text-2xl" data-swiper-parallax-y="-200">
                Hjertelig velkommen til Påskecamp 2023!
            </p>
        </div>
        <div class="mb-8 w-full" style="padding-bottom: 100px">
            <div class="relative flex justify-end pointer-events-none">
                <img
                    src="https://static.bcc.media/images/pc23/kaare1.png"
                    class="pl-8 select-none"
                    style="min-width: 100%"
                />
                <div
                    class="absolute right-[-20%] bottom-[20px] z-10"
                    data-swiper-parallax-y="-100"
                    style="width: 60%"
                >
                    <SotmShapeLong
                        color="#B16B35"
                        style="transform: rotate(-368deg)"
                    >
                    </SotmShapeLong>
                </div>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import SotmShapeLong from "./SotmShapeLong.vue"
defineProps<{ displayName: string | undefined }>()
</script>
