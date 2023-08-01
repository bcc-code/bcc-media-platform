<script lang="ts" setup>
import { GetEpisodeEmbedQuery } from "@/graph/generated"
import { languages as langs } from "@/services/language"
import { computed, onMounted, ref } from "vue"

const props = defineProps<{
    episode: GetEpisodeEmbedQuery["episode"]
}>()

const languages = computed(() => {
    const r: string[] = []

    for (const f of props.episode.files) {
        if (!r.includes(f.audioLanguage)) {
            r.push(f.audioLanguage)
        }
    }

    return r.map((i) => langs.value.find((l) => l.code === i)!).filter((i) => i)
})

const _language = ref<string>()

const language = computed({
    get() {
        return _language.value
    },
    set(v) {
        _language.value = v
        file.value = undefined
    },
})

const files = computed(() => {
    if (!language.value) {
        return props.episode.files
    }

    return props.episode.files.filter((f) => f.audioLanguage === language.value)
})

const file = ref<GetEpisodeEmbedQuery["episode"]["files"][0]>()

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

const progress = ref(0)

const downloading = ref(false)

const downloadFile = (url: string, name: string) => {
    downloading.value = true
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
        <div class="flex gap-4">
            <h1 class="text-lg font-bold my-auto uppercase">
                {{ $t("buttons.download") }}
            </h1>
            <select class="bg-primary p-2 rounded-md" v-model="language">
                <option v-for="l in languages" :key="l.code" :value="l.code">
                    {{ l.name }}
                </option>
            </select>
        </div>
        <select
            class="bg-primary p-2 rounded-md"
            v-model="file"
            v-if="language"
        >
            <option v-for="f in files" :key="f.id" :value="f">
                {{ f.resolution }}
                <span v-if="f.size > 0">({{ fileSize(f.size) }})</span>
            </option>
        </select>
        <button
            class="bg-primary p-2 rounded-md"
            :class="{
                'opacity-50 cursor-not-allowed': downloading,
            }"
            v-if="file"
            @click="downloadFile(file?.url, file?.fileName)"
            :disabled="downloading"
        >
            {{ $t("buttons.download") }}
        </button>
        <div
            class="w-64 flex bg-black my-auto h-8 rounded p-2"
            v-if="file && downloading"
        >
            <div
                class="bg-primary h-4 rounded my-auto"
                :style="{
                    width: (progress / file.size) * 100 + '%',
                }"
            ></div>
        </div>
    </section>
</template>
