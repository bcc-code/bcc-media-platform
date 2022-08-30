<template>
    <div class="w-screen h-screen bg-primary">
        <Navbar></Navbar>
        <div class="mx-auto max-w-screen-lg">
            <router-view></router-view>
        </div>
    </div>
</template>
<script lang="ts" setup>
import Navbar from "@/components/navbar/Navbar.vue"
</script>
