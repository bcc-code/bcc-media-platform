<script lang="ts" setup>
import {
    ExclamationTriangleIcon,
    InformationCircleIcon,
    XCircleIcon,
} from '@heroicons/vue/24/outline'
import SectionTitle from './item/SectionTitle.vue'
import { Section } from './types'
import { MessageStyleVariant } from '@/graph/generated'
import { mdToHTML } from '@/services/converter'

defineProps<{
    item: Section & { __typename: 'MessageSection' }
}>()

const icons = {
    [MessageStyleVariant.Info]: InformationCircleIcon,
    [MessageStyleVariant.Warning]: ExclamationTriangleIcon,
    [MessageStyleVariant.Error]: XCircleIcon,
}

const iconFor = (variant: MessageStyleVariant) =>
    icons[variant] ?? InformationCircleIcon
</script>
<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex flex-col w-full gap-4">
            <div
                v-for="m in (item.messages ?? []).filter((m) => m.content)"
                :key="`${m.title}-${m.content}`"
                class="message flex items-start gap-3 w-full lg:max-w-2xl rounded-2xl px-4 py-3.5"
                :class="`message-${m.variant}`"
            >
                <component
                    :is="iconFor(m.variant)"
                    class="message-accent shrink-0 size-5 mt-0.5"
                />
                <div class="min-w-0 flex-1">
                    <h3 v-if="m.title" class="text-style-title-3 mb-1">
                        {{ m.title }}
                    </h3>
                    <div
                        class="message-content text-style-body-2"
                        v-html="mdToHTML(m.content)"
                    ></div>
                </div>
            </div>
        </div>
    </section>
</template>
<style scoped>
.message-info {
    --message-bg: var(--color-message-info-bg);
    --message-text: var(--color-message-info-text);
    --message-accent: var(--color-message-info-accent);
}
.message-warning {
    --message-bg: var(--color-message-warning-bg);
    --message-text: var(--color-message-warning-text);
    --message-accent: var(--color-message-warning-accent);
}
.message-error {
    --message-bg: var(--color-message-error-bg);
    --message-text: var(--color-message-error-text);
    --message-accent: var(--color-message-error-accent);
}

.message {
    background-color: rgb(var(--message-bg));
    color: rgb(var(--message-text));
}

.message-accent {
    color: rgb(var(--message-accent));
}

.message-content :deep(a) {
    color: rgb(var(--message-accent));
    text-decoration: underline;
}
</style>
