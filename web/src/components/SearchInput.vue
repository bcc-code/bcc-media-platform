<template>
    <div class="relative flex" :class="[disabled ? 'opacity-50' : '']">
        <SearchIcon
            class="absolute pointer-events-none left-0 inset-y-0 my-auto ml-2"
        ></SearchIcon>
        <input
            v-model="value"
            type="text"
            :disabled="disabled"
            class="pl-10 w-full bg-slate-800 rounded-full pr-20 p-2 my-auto text-md"
            :class="[disabled ? 'text-gray' : '']"
            :placeholder="$t('page.search')"
            @keydown.enter="emit('keydown.enter')"
        />
        <p
            v-if="value"
            class="absolute flex right-2 ml-10 px-2 inset-y-2 cursor-pointer text-xs opacity-50 bg-slate-700 rounded-full"
            @click="cancel"
        >
            <span class="my-auto uppercase">{{ $t("search.cancel") }}</span>
        </p>
    </div>
</template>
<script lang="ts" setup>
import { useSearch } from "@/utils/search";
import { computed, nextTick } from "vue"
import { useRouter } from "vue-router"
import { SearchIcon } from "./icons"

const { oldPath } = useSearch()

const router = useRouter()

const props = defineProps<{
    modelValue: any
    disabled?: boolean
}>()

const emit = defineEmits<{
    (e: "update:modelValue", value: any): void
    (e: "keydown.enter"): void
}>()

const value = computed({
    get() {
        return props.modelValue
    },
    set(v) {
        emit("update:modelValue", v)
        nextTick().then(() => {

            if (router.currentRoute.value.name === "search" && !v && oldPath.value) {
                router.push(oldPath.value).then(r => {
                    console.log(r)
                })
                console.log(oldPath.value)
            } else if (router.currentRoute.value.name !== "search" && v) {
                oldPath.value = router.currentRoute.value

                router.replace({
                    name: "search",
                })
            }
            })
    },
})

const cancel = () => {
    value.value = ""
    if (router.currentRoute.value.name === "search" && oldPath.value) {
        router.replace(oldPath.value)
    }
}
</script>
