<template>
    <div class="w-full relative">
        <div
            class="w-full bg-background-2 rounded-xl border-separator-on-light border select-none cursor-pointer"
        >
            <div class="p-3 flex items-center">
                <div class="pr-3">
                    <svg
                        width="24"
                        height="25"
                        viewBox="0 0 24 25"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <circle cx="12" cy="12.5" r="12" fill="white" />
                        <path
                            d="M18.5387 8.5533L10.0534 17.0386L5.75007 12.7353"
                            stroke="#0D1623"
                            stroke-width="2"
                        />
                    </svg>
                </div>
                <div class="flex-1 flex flex-col">
                    <span class="text-style-title-3 text-on-tint"
                        >Lesson activity</span
                    >
                    <span class="text-style-caption-1 text-label-2"></span>
                </div>
                <div class="pl-3">
                    <div
                        class="bg-separator-on-light rounded-full h-9 w-9 flex items-center justify-center border border-separator-on-light"
                    >
                        <svg
                            width="8"
                            height="12"
                            viewBox="0 0 8 12"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                d="M0.958984 0.897949L6.06103 5.99999L0.958984 11.102"
                                stroke="white"
                                stroke-width="1.53061"
                            />
                        </svg>
                    </div>
                </div>
            </div>
            <div
                class="shine-overlay absolute top-0 right-0 w-full h-full rounded-xl"
            ></div>
        </div>
        <svg width="0" height="0">
            <defs>
                <clipPath id="myCurve" clipPathUnits="objectBoundingBox">
                    <path
                        d="M 0,1
              L .55, 1
              C .6 .5, .7 .3, .75 0
              L 1,0
              L 1,1
              Z"
                    />
                </clipPath>
            </defs>
        </svg>
    </div>
</template>

<script lang="ts" setup>
const props = defineProps<{ title: string; secondaryTitle: string }>()
</script>

<style scoped>
.shine-overlay {
    clip-path: url(#myCurve);
    /*
    background-image: url("data:image/svg+xml,%3Csvg width='167' height='65' viewBox='0 0 167 65' fill='none' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M48.5713 24.5C17.3713 50.5 3.57129 81.3333 0.571289 93.5H209.071V-25H88.5713C88.238 -19.3333 79.7713 -1.5 48.5713 24.5Z' fill='url(%23paint0_linear_7738_134762)' fill-opacity='0.1'/%3E%3Cdefs%3E%3ClinearGradient id='paint0_linear_7738_134762' x1='104.821' y1='-25' x2='104.821' y2='93.5' gradientUnits='userSpaceOnUse'%3E%3Cstop stop-color='%23CCDDFF'/%3E%3Cstop stop-color='%23EDF3FE'/%3E%3Cstop offset='1' stop-color='%23CCDDFF' stop-opacity='0'/%3E%3C/linearGradient%3E%3C/defs%3E%3C/svg%3E");
 */

    background: linear-gradient(
        180deg,
        rgba(204, 221, 255, 0.1) 0%,
        rgba(237, 243, 254, 0.1) 0%,
        rgba(204, 221, 255, 0) 100%
    );
}
</style>
