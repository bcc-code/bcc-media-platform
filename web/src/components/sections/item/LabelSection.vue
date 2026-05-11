<script lang="ts" setup>
import { Section } from '../types'
import { isModifiedClick, itemHref } from '@/utils/items'

const props = defineProps<{
    position: number
    item: Section & { __typename: 'LabelSection' }
}>()

const emit = defineEmits<{
    (event: 'clickItem', index: number, isModified: boolean): void
}>()

// eslint-disable-next-line no-undef
const handleClick = (event: MouseEvent, index: number, href: string | null) => {
    const modified = !!href && isModifiedClick(event)
    emit('clickItem', index, modified)
    if (modified) return
    if (href) event.preventDefault()
}

const hrefFor = (index: number) =>
    itemHref(props.item.items.items[index], {
        useContext: false,
        collectionId: '',
    })
</script>
<template>
    <section>
        <h2 v-if="item.title" class="text-lg">
            {{ item.title }}
        </h2>
        <div class="flex gap-2">
            <component
                :is="hrefFor(index) ? 'a' : 'div'"
                v-for="(i, index) in item.items.items"
                :key="i.id"
                :href="hrefFor(index) ?? undefined"
                class="bg-slate-800 px-3 py-0.5 border border-1 border-slate-700 rounded-full cursor-pointer"
                @click="handleClick($event, index, hrefFor(index))"
            >
                <p class="text-lg">{{ i.title }}</p>
            </component>
        </div>
    </section>
</template>
