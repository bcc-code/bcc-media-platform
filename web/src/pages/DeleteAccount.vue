<template>
    <div class="flex p-5">
        <div class="mx-auto mt-10 text-center">
            <h1 class="text-2xl font-bold text-white mb-2">
                Delete my account
            </h1>
            <p class="max-w-sm text-lg mb-6">
                To delete your account, please contact us at
                <a class="underline" href="mailto:support@bcc.media"
                    >support@bcc.media</a
                >
                from the email address associated with your account.<br />
                We will then send you a confirmation email to verify your
                request.
            </p>
            <router-link
                v-if="link"
                :to="{ name: 'front-page' }"
                class="text-gray m-2 hover:underline hover:text-white transition hover:bg-slate-400 bg-primary-light p-2 px-3 rounded-full"
                href="/"
                >{{ $t("notFound.returnHome") }}</router-link
            >
        </div>
    </div>
</template>
<script lang="ts" setup>
withDefaults(
    defineProps<{
        title?: string
        description?: string
        link?: boolean
    }>(),
    {
        link: true,
    }
)
</script>
