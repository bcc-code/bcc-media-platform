<template>
    <button class="v-button button align-center normal">
        <slot />
    </button>
</template>
<style scoped>
.v-button {
    border-width: 2px;
    border-style: solid;
    border-radius: 10px;
    padding: 5px;
    margin: 5px;
    background-color: #8866ff;
    color: #0d1117;
}

.v-button:hover {
    border-color: #31363d;
    background-color: #a48bff;
}
</style>