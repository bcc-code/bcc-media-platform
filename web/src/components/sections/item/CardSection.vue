<script lang="ts" setup>
import { Section } from '../types'
import SectionTitle from './SectionTitle.vue'
import { computed } from 'vue'
import StudyTopicCardLarge from './cards/StudyTopicCardLarge.vue'

const props = defineProps<{
    item: Section & { __typename: 'CardSection' }
}>()

defineEmits<{
    (event: 'clickItem', index: number): void
}>()

const filteredItems = computed(() =>
    props.item.items.items.filter((i) => i.item.__typename === 'StudyTopic')
)
</script>
<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex gap-4">
            <div v-for="(i, index) in filteredItems">
                <StudyTopicCardLarge
                    v-if="
                        item.cardSize == 'large' &&
                        i.item.__typename === 'StudyTopic'
                    "
                    ref="sectionItem"
                    :item="i.item"
                    @click="$emit('clickItem', index)"
                >
                </StudyTopicCardLarge>
            </div>
        </div>
    </section>
</template>
