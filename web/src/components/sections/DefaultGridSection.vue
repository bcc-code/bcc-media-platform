<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="grid grid-cols-2">
            <div v-for="i in item.items.items" class="relative">
                <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
                <div
                    class="flex flex-col cursor-pointer mx-2 mt-2"
                    @click="goToSectionItem(i)"
                >
                    <img
                        :src="i.image ?? ''"
                        class="rounded-md top-0 h-full w-full object-cover mb-1"
                    />
                    <SectionItemTitle :i="i"></SectionItemTitle>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import { computed } from "vue"
import SectionTitle from "./SectionTitle.vue"
import { useI18n } from "vue-i18n"
import NewPill from "./NewPill.vue"
import { goToSectionItem } from "@/utils/items"
import SectionItemTitle from "./SectionItemTitle.vue"

const { t } = useI18n()

const props = defineProps<{
    item: Section & { __typename: "DefaultGridSection" }
}>()

const imageSize = computed(() => {
    return {
        half: {
            height: 225,
            width: 400,
        },
    }[props.item.gridSize]
})
</script>
