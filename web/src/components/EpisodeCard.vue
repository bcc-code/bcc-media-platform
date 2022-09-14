<template>
    <div class="flex">
        <img
            class="max-w-sm rounded rounded-xl"
            v-if="item.imageUrl"
            :src="item.imageUrl"
        />
        <div>
            <h1>{{ item.number }} {{ item.title }}</h1>
            <p>{{ item.description }}</p>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { GetSeasonQuery } from "@/graph/generated"
import { randomImageUrl } from "@/utils/randomImage"

const props = defineProps<{
    item: NonNullable<GetSeasonQuery["season"]>["episodes"]["items"][0]
}>()

if (!props.item.imageUrl) {
    props.item.imageUrl = randomImageUrl()
}
</script>
