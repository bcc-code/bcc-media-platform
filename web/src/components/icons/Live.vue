<template>
    <svg
        v-if="!selected"
        width="28"
        height="28"
        viewBox="0 0 28 28"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
    >
        <rect
            x="1"
            y="5"
            width="26"
            height="18"
            rx="9"
            stroke="#B4C0D2"
            stroke-width="2"
        />
        <path
            d="M17.7111 13.1056C18.4482 13.4741 18.4482 14.5259 17.7111 14.8944L11.9472 17.7764C11.2823 18.1088 10.5 17.6253 10.5 16.882V11.118C10.5 10.3747 11.2823 9.89116 11.9472 10.2236L17.7111 13.1056Z"
            fill="#B4C0D2"
        />
    </svg>
    <svg
        v-else
        width="28"
        height="28"
        viewBox="0 0 28 28"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
    >
        <path
            fill-rule="evenodd"
            clip-rule="evenodd"
            d="M10 4C4.47715 4 0 8.47715 0 14C0 19.5228 4.47715 24 10 24H18C23.5228 24 28 19.5228 28 14C28 8.47715 23.5228 4 18 4H10ZM11.9472 17.7764L17.7111 14.8944C18.4482 14.5259 18.4482 13.4741 17.7111 13.1056L11.9472 10.2236C11.2823 9.89116 10.5 10.3747 10.5 11.118V16.882C10.5 17.6253 11.2823 18.1088 11.9472 17.7764Z"
            fill="url(#paint0_linear_0_1132)"
        />
        <defs>
            <linearGradient
                id="paint0_linear_0_1132"
                x1="0"
                y1="4"
                x2="0"
                y2="24"
                gradientUnits="userSpaceOnUse"
            >
                <stop stop-color="#A071A5" />
                <stop offset="1" stop-color="#57A7E9" />
            </linearGradient>
        </defs>
    </svg>
</template>
<script lang="ts" setup>
defineProps<{
    selected?: boolean
}>()
</script>
