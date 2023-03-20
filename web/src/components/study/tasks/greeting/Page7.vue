<template>
    <div
        class="w-full h-full point-events-none flex flex-col justify-center items-center relative"
        style="padding-bottom: env(safe-area-inset-bottom)"
    >
        <div class="h-32">&nbsp;</div>
        <div class="py-8 px-12 text-left">
            <p class="mt-3 text-2xl" data-swiper-parallax-y="-200">
                <span class="bg-[#FEECD0] bg-opacity-75">
                    Det kommer til å lykkes<span v-if="displayName"
                        >, kjære {{ displayName }}</span
                    >.
                </span>
            </p>
            <p class="mt-3 text-2xl" data-swiper-parallax-y="-200">
                <span class="bg-[#FEECD0] bg-opacity-75">
                    Din bror,
                    <br />
                    Kåre J. Smith
                </span>
            </p>
        </div>
        <div
            class="absolute right-[-25%] top-[120px] -z-50"
            data-swiper-parallax-y="-50"
            style="width: 70%"
        >
            <SotmShapeLong color="#B16B35" style="transform: rotate(-41deg)">
            </SotmShapeLong>
        </div>
        <div
            class="absolute right-[-40%] top-[0] -z-10"
            style="width: 70%"
            data-swiper-parallax-y="-150"
        >
            <SotmShapeLong color="#536C5B" style="transform: rotate(-41deg)">
            </SotmShapeLong>
        </div>
    </div>
</template>

<script lang="ts" setup>
import SotmShapeLong from "./SotmShapeLong.vue"
defineProps<{ displayName: string | undefined }>()
</script>
