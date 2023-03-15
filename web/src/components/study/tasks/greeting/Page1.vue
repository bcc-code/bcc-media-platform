<template>
    <div
        class="point-events-none h-screen snap-center relative flex flex-col items-center mb-48"
        :ref="(el) => (targetScrollEl = el as any)"
    >
        <template v-if="targetScrollEl != null">
            <div
                class="mt-6 px-16 text-right flex-1 justify-center flex flex-col"
            >
                <Parallax
                    :parentScrollEl="parentScrollEl"
                    :targetScrollEl="targetScrollEl!"
                    :scrollHandler="animate(-0.3)"
                >
                    <p class="font-bold text-2xl">Kjære {{ displayName }}</p>
                </Parallax>
                <Parallax
                    :parentScrollEl="parentScrollEl"
                    :targetScrollEl="targetScrollEl!"
                    :scrollHandler="animate(-0.2)"
                >
                    <p class="mt-5 text-2xl">
                        Hjertelig velkommen til Påskecamp 2023!
                    </p>
                </Parallax>
            </div>
            <div class="mb-24">
                <div class="relative flex justify-end pointer-events-none">
                    <img
                        src="https://static.bcc.media/images/pc23/kaare1.png"
                        class="pl-8 select-none"
                        style="min-width: 100%"
                    />
                    <Parallax
                        :parentScrollEl="parentScrollEl"
                        :targetScrollEl="targetScrollEl!"
                        :scrollHandler="animate(-0.05)"
                    >
                        <div class="absolute right-[-20px] bottom-[30px]">
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
</template>

<script lang="ts" setup>
import Auth from "@/services/auth"
import { ref } from "vue"
import Parallax from "./Parallax.vue"

const props = defineProps<{ parentScrollEl: Element }>()

const pages = [""]
const displayName = ref("")
const targetScrollEl = ref<Element | null>(null)

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
