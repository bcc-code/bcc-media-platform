<script lang="ts" setup>
import { StudyTopicSectionItemFragment } from '@/graph/generated'
import { computed } from 'vue'
import Image from '@/components/Image.vue'
import { VButton } from '@/components'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const props = defineProps<{
    item: StudyTopicSectionItemFragment
}>()

const image = computed(
    () => props.item.images.find((i) => i.style == 'featured')?.url
)
</script>

<template>
    <div class="overflow-clip w-full lg:w-96 hover:opacity-90 transition">
        <div class="bg-background-2 rounded-2xl cursor-pointer overflow-hidden">
            <Image
                :draggable="false"
                class="w-full"
                :src="image"
                size-source="height"
                :ratio="16 / 9"
            />

            <h3
                class="px-4 text-style-title-1 text-label-1 lg:text-lg line-clamp-2 mt-3"
            >
                {{ item.title }}
            </h3>
            <p class="px-4 mt-2 text-style-body-2 text-label-2">
                {{ item.description }}
            </p>
            <div class="px-4 mb-5 mt-6 w-full flex justify-end">
                <VButton
                    class="bg-separator-on-light"
                    color="secondary"
                    size="thin"
                    ><svg
                        class="-mt-1 mr-1 inline"
                        width="18"
                        height="18"
                        viewBox="0 0 18 18"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            fill-rule="evenodd"
                            clip-rule="evenodd"
                            d="M16.1097 11.9993C18.6301 10.6538 18.6301 7.34616 16.1097 6.00073L5.7785 0.485707C3.22237 -0.878811 0 0.793724 0 3.48497V14.515C0 17.2063 3.22237 18.8788 5.7785 17.5143L16.1097 11.9993Z"
                            fill="white"
                        />
                    </svg>
                    {{
                        item.lessonsProgress.completed > 0
                            ? t('study.continueStudy')
                            : t('study.startStudy')
                    }}</VButton
                >
            </div>
        </div>
    </div>
</template>
