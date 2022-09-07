<template>
    <div>
        <Navbar></Navbar>
        <div class="p-4">
            <router-view></router-view>
        </div>
        <div class="text-red-500" v-if="errors">
            <p v-for="(error, i) in errors">
                {{ error.title }}
                <span @click="removeError(i)" class="cursor-pointer">X</span>
            </p>
        </div>
    </div>
</template>
<script lang="ts" setup>
import Navbar from "@/components/navbar/Navbar.vue"
import { errors, removeError } from "@/utils/error"
</script>
