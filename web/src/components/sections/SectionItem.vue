<template>
    <div class="relative w-48 p-2">
        <div class="rounded bg-primary-light aspect-video">
            <img class="w-full" src="https://brunstadtv.imgix.net/BIHE_S01_E02_MUL.jpg" />
        </div>
        <div class="w-full mt-2">
            <div class="flex w-full"> 
                <p class="w-full text-sm truncate">{{item.header}}</p>
                <p class="w-full shrink float-right grow-0 text-sm truncate text-right">{{item.header2}}</p>
            </div>
            <p class="truncate">{{item.title}}</p>
        </div>
    </div>
</template>
<script lang="ts" setup>

export type Item = {
    type: "show" | "season" | "episode" | "page" | "url" | null
    header?: string;
    header2?: string;
    title: string;
    image?: string;
}

defineProps<{
    item: Item
}>()

</script>