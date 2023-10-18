<script lang="ts" setup>
import { GetEpisodeEmbedQuery } from "@/graph/generated"
import { Language, getLanguage } from "@/services/language"
import { computed, ref } from "vue"
import { DocumentArrowDownIcon } from "@heroicons/vue/24/outline"
import { analytics } from "@/services/analytics"
import ModalBase from "../study/ModalBase.vue"
import { mdToHTML } from "@/services/converter"

const props = defineProps<{
    episode: GetEpisodeEmbedQuery["episode"]
    showTitle?: boolean
}>()

const languages = computed(() => {
    const langs: Language[] = []

    for (const f of props.episode.files) {
        if (!langs.some((l) => l.code == f.audioLanguage)) {
            langs.push(
                getLanguage({
                    languageCode: f.audioLanguage,
                    currentLanguageCode: "en",
                })
            )
        }
    }

    return langs
})

const _language = ref<string>("")

const language = computed({
    get() {
        return _language.value
    },
    set(v) {
        _language.value = v
        fileId.value = ""
    },
})

const files = computed(() => {
    if (!language.value) {
        return props.episode.files
    }

    return props.episode.files.filter((f) => f.audioLanguage === language.value)
})

const fileId = ref<string>("")

const file = computed(() => {
    return props.episode.files.find((f) => f.id === fileId.value)
})

const fileSize = (bytes: number) => {
    const threshhold = 1024

    if (Math.abs(bytes) < threshhold) {
        return bytes + " B"
    }

    const units = ["KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"]
    let u = -1
    const r = 10 ** 1

    do {
        bytes /= threshhold
        ++u
    } while (
        Math.round(Math.abs(bytes) * r) / r >= threshhold &&
        u < units.length - 1
    )

    return bytes.toFixed(1) + " " + units[u]
}

const showTerms = ref(false)

const progress = ref(0)

const downloading = ref(false)

const downloadFile = () => {
    showTerms.value = false
    if (!file.value) {
        return
    }
    const url = file.value.url
    const name = file.value.fileName
    downloading.value = true
    analytics.track("episode_download", {
        episodeId: props.episode.id,
        fileName: name,
        audioLanguage: file.value.audioLanguage,
        resolution: file.value.resolution ?? "",
    })
    fetch(url)
        .then((response) => {
            const contentEncoding = response.headers.get("content-encoding")
            const contentLength = response.headers.get(
                contentEncoding ? "x-file-size" : "content-length"
            )

            if (contentLength === null) {
                throw Error("Response size header unavailable")
            }

            let loaded = 0

            return new Response(
                new ReadableStream({
                    start(controller) {
                        const reader = response.body!.getReader()

                        read()

                        function read() {
                            reader
                                .read()
                                .then(({ done, value }) => {
                                    if (done) {
                                        controller.close()
                                        return
                                    }
                                    loaded += value.byteLength
                                    progress.value = loaded
                                    controller.enqueue(value)
                                    read()
                                })
                                .catch((error) => {
                                    console.error(error)
                                    controller.error(error)
                                })
                        }
                    },
                })
            )
        })
        .then((response) => response.blob())
        .then((blob) => {
            const link = document.createElement("a")
            link.download = name
            link.href = URL.createObjectURL(blob)
            link.click()
            downloading.value = false
        })
}
</script>

<template>
    <section
        class="flex gap-4 p-4 overflow-y-scroll"
        v-if="episode.files.length"
    >
        <TransitionGroup
            enter-active-class="duration-100 ease-out"
            enter-from-class="transform opacity-0"
            enter-to-class="opacity-100"
            leave-active-class="duration-50 ease-in"
            leave-from-class="opacity-100"
            leave-to-class="transform opacity-0"
        >
            <div class="flex flex-col gap-2" v-if="showTitle">
                <h1 class="text-lg font-bold my-auto uppercase">
                    {{ $t("buttons.download") }}
                </h1>
            </div>
            <div class="flex flex-col gap-2">
                <select
                    class="bg-primary-light p-2 h-12 rounded-md"
                    :class="{ 'text-gray': !language }"
                    v-model="language"
                >
                    <option value="" disabled selected hidden>
                        {{ $t("download.language") }}
                    </option>
                    <option
                        v-for="l in languages"
                        :key="l.code"
                        :value="l.code"
                    >
                        {{ l.name }}
                    </option>
                </select>
            </div>
            <div class="flex flex-col gap-2" v-if="language" :key="language">
                <select
                    class="bg-primary-light p-2 h-12 rounded-md"
                    :class="{ 'text-gray': !fileId }"
                    v-model="fileId"
                >
                    <option value="" disabled selected hidden>
                        <span class="text-opacity-50">{{
                            $t("download.resolution")
                        }}</span>
                    </option>
                    <option v-for="f in files" :value="f.id">
                        {{ f.resolution }}
                        <span v-if="f.size > 0">({{ fileSize(f.size) }})</span>
                    </option>
                </select>
            </div>
            <div class="flex flex-col gap-2" v-if="file">
                <button
                    class="bg-primary-light p-2 h-12 rounded-md gap-2"
                    :class="{
                        'opacity-50 cursor-not-allowed': downloading,
                    }"
                    @click="showTerms = true"
                    :disabled="downloading"
                >
                    <!-- <span class="my-auto">{{ $t("buttons.download") }}</span> -->
                    <DocumentArrowDownIcon class="h-6 w-6 mx-auto" />
                </button>
            </div>
            <div class="flex flex-col gap-2" v-if="file && downloading">
                <div
                    class="w-64 flex bg-black bg-opacity-20 my-auto h-8 rounded p-2"
                >
                    <div
                        class="bg-primary h-4 rounded my-auto"
                        :style="{
                            width: (progress / file.size) * 100 + '%',
                        }"
                    ></div>
                </div>
            </div>
        </TransitionGroup>
        <ModalBase v-model:visible="showTerms">
            <div class="bg-background rounded-lg p-4 flex flex-col">
                <div>
                    <h3>{{ $t("footer.termsOfUse") }}</h3>
                    <div
                        class="terms"
                        v-html="
                            mdToHTML($t('terms.byDownloadingYouAcceptTerms'))
                        "
                    ></div>
                </div>
                <div class="flex gap-2 ml-auto">
                    <button
                        class="bg-primary-light px-4 py-2 rounded-md"
                        :class="{
                            'opacity-50 cursor-not-allowed': downloading,
                        }"
                        @click="showTerms = false"
                        :disabled="downloading"
                    >
                        <span class="my-auto">{{ $t("buttons.cancel") }}</span>
                    </button>
                    <button
                        class="bg-primary px-4 py-2 rounded-md"
                        :class="{
                            'opacity-50 cursor-not-allowed': downloading,
                        }"
                        @click="downloadFile"
                        :disabled="downloading"
                    >
                        <span class="my-auto">{{ $t("buttons.accept") }}</span>
                    </button>
                </div>
            </div>
        </ModalBase>
    </section>
</template>
<style>
div.terms a {
    color: var(--color-tint-1);
}
</style>
