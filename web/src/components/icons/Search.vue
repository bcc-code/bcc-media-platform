<template>
    <svg
        v-if="!selected"
        width="28"
        height="28"
        viewBox="0 0 28 28"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
    >
        <path
            fill-rule="evenodd"
            clip-rule="evenodd"
            d="M5 13C5 8.58172 8.58172 5 13 5C17.4183 5 21 8.58172 21 13C21 17.4183 17.4183 21 13 21C8.58172 21 5 17.4183 5 13ZM13 3C7.47715 3 3 7.47715 3 13C3 18.5228 7.47715 23 13 23C15.4013 23 17.6049 22.1536 19.3287 20.7429L24.2929 25.7071L25.7071 24.2929L20.7429 19.3287C22.1536 17.6049 23 15.4013 23 13C23 7.47715 18.5228 3 13 3Z"
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
            d="M23 13C23 7.47715 18.5228 3 13 3C7.47715 3 3 7.47715 3 13C3 18.5228 7.47715 23 13 23C15.4009 23 17.6042 22.1539 19.3279 20.7436L24.2929 25.7071L25.7071 24.2929L20.7436 19.3279C22.1539 17.6042 23 15.4009 23 13ZM5 13C5 8.58172 8.58172 5 13 5C17.4183 5 21 8.58172 21 13C21 17.4183 17.4183 21 13 21C8.58172 21 5 17.4183 5 13Z"
            fill="url(#paint0_linear_0_1192)"
        />
        <defs>
            <linearGradient
                id="paint0_linear_0_1192"
                x1="3"
                y1="3"
                x2="3"
                y2="25.7071"
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
