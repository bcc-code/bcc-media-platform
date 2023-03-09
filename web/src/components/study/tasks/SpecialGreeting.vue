<template>
    <div
        class="fixed top-0 left-0 w-screen h-screen bg-[#FEECD0] z-50 text-[#422E1C] overflow-y-scroll overflow-x-hidden hide-scrollbar snap-mandatory snap-y"
        :ref="(el) => (parentScrollEl = el as any)"
    >
        <template v-if="parentScrollEl != null">
            <div
                class="point-events-none h-screen snap-center relative flex flex-col items-center"
                :ref="(el) => (targetScrollEl = el as any)"
            >
                <template v-if="targetScrollEl != null">
                    <div
                        class="mt-6 px-16 text-right flex-1 justify-center flex flex-col"
                    >
                        <Parallax
                            :parentScrollEl="parentScrollEl!"
                            :targetScrollEl="targetScrollEl!"
                            :scrollHandler="animate(-0.3)"
                        >
                            <p class="font-bold text-2xl">
                                Kjære {{ displayName }}
                            </p>
                        </Parallax>
                        <Parallax
                            :parentScrollEl="parentScrollEl!"
                            :targetScrollEl="targetScrollEl!"
                            :scrollHandler="animate(-0.2)"
                        >
                            <p class="mt-5 text-2xl">
                                Hjertelig velkommen til Påskecamp 2023!
                            </p>
                        </Parallax>
                    </div>
                    <div class="mb-24">
                        <div
                            class="relative flex justify-end pointer-events-none"
                        >
                            <img
                                src="https://static.bcc.media/images/pc23/kaare1.png"
                                class="pl-8 select-none"
                                style="min-width: 100%"
                            />
                            <Parallax
                                :parentScrollEl="parentScrollEl!"
                                :targetScrollEl="targetScrollEl!"
                                :scrollHandler="animate(-0.05)"
                            >
                                <div
                                    class="absolute right-[-20px] bottom-[30px]"
                                >
                                    <svg
                                        style="width: 50vw"
                                        viewBox="0 0 200 94"
                                        fill="none"
                                        xmlns="http://www.w3.org/2000/svg"
                                    >
                                        <path
                                            d="M190.446 0.00589789L33.5669 22.0183C17.8486 24.2238 5.76749 37.0418 4.5021 52.8593C2.76762 74.477 21.506 92.1361 42.9826 89.1226L184.892 69.2106L190.445 4.46952e-05L190.446 0.00589789Z"
                                            fill="#B16B35"
                                        />
                                    </svg>
                                </div>
                            </Parallax>
                        </div>
                    </div>
                </template>
            </div>
            <div
                class="point-events-none mt-24 h-screen snap-center relative flex items-center"
                :ref="(el) => (targetScrollEl2 = el as any)"
            >
                <template v-if="targetScrollEl2 != null">
                    <div class="py-8 px-16 text-left">
                        <Parallax
                            :parentScrollEl="parentScrollEl!"
                            :targetScrollEl="targetScrollEl2!"
                            :scrollHandler="animate(-0.2)"
                        >
                            <p class="mt-3 text-2xl">
                                <span class="bg-[#FEECD0] bg-opacity-75"
                                    >Du kan glede deg til noen innholdsrike
                                    dager full av samfunn, oppbyggelse og
                                    trivsel. Denne campen er høydepunktet og
                                    selve avslutningen for prosjektet om
                                    Bergprekenen som du også har vært med
                                    på.</span
                                >
                            </p>
                        </Parallax>
                    </div>
                    <div
                        class="absolute right-[-25vw] top-[120px] -z-50"
                        style="width: 70vw; transform: rotate(-30deg)"
                    >
                        <Parallax
                            :parentScrollEl="parentScrollEl!"
                            :targetScrollEl="targetScrollEl2!"
                            :scrollHandler="animate(-0.05)"
                        >
                            <SotmShapeLong color="#B16B35"> </SotmShapeLong>
                        </Parallax>
                    </div>
                    <div
                        class="absolute right-[-40vw] top-[0]"
                        style="width: 70vw; transform: rotate(-30deg)"
                    >
                        <Parallax
                            :parentScrollEl="parentScrollEl!"
                            :targetScrollEl="targetScrollEl2!"
                            :scrollHandler="animate(-0.1)"
                        >
                            <SotmShapeLong color="#536C5B"> </SotmShapeLong>
                        </Parallax>
                    </div>
                    <div
                        class="absolute left-[-25vw] bottom-[120px] -z-50"
                        style="width: 70vw; transform: rotate(-210deg)"
                    >
                        <Parallax
                            :parentScrollEl="parentScrollEl!"
                            :targetScrollEl="targetScrollEl2!"
                            :scrollHandler="animate(-0.05)"
                        >
                            <SotmShapeLong color="#B16B35"> </SotmShapeLong>
                        </Parallax>
                    </div>
                    <div
                        class="absolute left-[-40vw] bottom-[0]"
                        style="width: 70vw; transform: rotate(-210deg)"
                    >
                        <Parallax
                            :parentScrollEl="parentScrollEl!"
                            :targetScrollEl="targetScrollEl2!"
                            :scrollHandler="animate(-0.1)"
                        >
                            <SotmShapeLong color="#536C5B"> </SotmShapeLong>
                        </Parallax>
                    </div>
                </template>
            </div>
        </template>
    </div>
</template>

<script lang="ts" setup>
import Auth from "@/services/auth"
import { onMounted, onUnmounted, ref } from "vue"
import SotmShapeLong from "./greeting/SotmShapeLong.vue"
import { init } from "@sentry/vue"
import Parallax from "./greeting/Parallax.vue"

const pages = [""]
const displayName = ref("")
const parentScrollEl = ref<Element | null>(null)
const targetScrollEl = ref<Element | null>(null)
const targetScrollEl2 = ref<Element | null>(null)

const getUserInfo = async () => {
    let res = await fetch("https://login.bcc.no/userinfo", {
        headers: { Authorization: "Bearer " + (await Auth.getToken()) },
    })
    let response = await res.json()
    console.log(response)
    displayName.value = response.given_name
}

getUserInfo()

const animate = (ratio: number) => (diff: number) => {
    console.log(diff)
    return `transform: translate(0, ${-diff * ratio}px);`
}
</script>
