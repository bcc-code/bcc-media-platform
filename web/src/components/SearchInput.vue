<script lang="ts" setup>
import { useSearch } from '@/utils/search'
import { computed, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { SearchIcon } from './icons'
import { useI18n } from 'vue-i18n'
import { useDebounceFn } from '@vueuse/core'

const { oldPath } = useSearch()
const { t } = useI18n()

const router = useRouter()

const props = defineProps<{
    modelValue: string
    disabled?: boolean
}>()

const emit = defineEmits<{
    (e: 'update:modelValue', value: string): void
    (e: 'keydown.enter'): void
}>()

const debounce = useDebounceFn((fn: () => void) => fn(), 100, {
    maxWait: 500,
})
const value = computed({
    get() {
        return props.modelValue
    },
    set(v) {
        debounce(() => {
            emit('update:modelValue', v)
            nextTick().then(() => {
                if (
                    router.currentRoute.value.name === 'search' &&
                    !v &&
                    oldPath.value
                ) {
                    router.push(oldPath.value)
                } else if (router.currentRoute.value.name !== 'search' && v) {
                    oldPath.value = router.currentRoute.value

                    router.replace({
                        name: 'search',
                        query: {
                            q: props.modelValue,
                        },
                    })
                }
            })
        })
    },
})

const cancel = () => {
    value.value = ''
    if (router.currentRoute.value.name === 'search' && oldPath.value) {
        router.replace(oldPath.value)
    }
}
</script>
<template>
    <div class="relative flex" :class="[disabled ? 'opacity-50' : '']">
        <SearchIcon
            class="absolute pointer-events-none left-0 inset-y-0 my-auto ml-2"
        />
        <input
            v-model="value"
            type="text"
            :disabled="disabled"
            class="pl-10 w-full bg-slate-800 rounded-full pr-20 p-2 my-auto text-md focus-visible:ring-2 focus-visible:ring-white/75"
            :class="[disabled ? 'text-gray' : '']"
            :placeholder="t('page.search')"
            @keydown.enter="emit('keydown.enter')"
        />
        <button
            v-if="value"
            class="absolute flex right-2 ml-10 px-2 inset-y-2 cursor-pointer text-xs opacity-50 bg-slate-700 rounded-full focus-visible:ring-2 focus-visible:ring-white/75"
            @click="cancel"
        >
            <span class="my-auto uppercase">{{ t('search.cancel') }}</span>
        </button>
    </div>
</template>
