<script lang="ts" setup>
import { ref, defineExpose } from "vue"

const msg = ref("hello world")

const changeMsg = () => {
    msg.value = "change message"
}

defineExpose({
    changeMsg,
})
</script>
<template>
    <div>{{ msg }}</div>
</template>
