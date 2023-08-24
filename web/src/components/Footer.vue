<template>
    <div class="flex flex-col bg-black bg-opacity-20 mt-4 opacity-90">
        <div
            class="px-4 lg:px-20 py-4 flex gap-4 flex-col text-sm lg:text-base"
        >
            <div class="flex gap-4">
                <a
                    class="text-tint-1 hover:underline cursor-pointer"
                    @click="accepted = false"
                    >{{ $t("footer.cookies") }}</a
                >
                <a
                    href="https://bcc.media/personvern"
                    class="text-tint-1 hover:underline"
                    >{{ $t("footer.privacyPolicy") }}</a
                >
                <a
                    href="https://bcc.media/terms-of-use"
                    class="text-tint-1 hover:underline"
                    >{{ $t("footer.termsOfUse") }}</a
                >
            </div>
            <div
                id="footer-description"
                v-html="mdToHTML($t('footer.information'))"
            ></div>
            <div class="flex flex-col lg:flex-row gap-4 lg:gap-8">
                <div>
                    <h3>
                        <b>{{ $t("footer.headOffice") }}</b>
                    </h3>
                    <p>BCC Media STI</p>
                    <p>Vålerveien 159</p>
                    <p>1599 MOSS</p>
                    <p>Norway</p>
                </div>
                <div>
                    <h3>
                        <b>{{ $t("footer.contactUs") }}</b>
                    </h3>
                    <a href="mailto:support@bcc.media">support@bcc.media</a>
                </div>
                <div>
                    <h3>
                        <b>{{ $t("footer.downloadApp") }}</b>
                    </h3>
                    <div class="flex gap-2 mt-1">
                        <a href="https://apple.co/3VewzK9"
                            ><img src="/badges/app_store.png"
                        /></a>
                        <a
                            href="https://play.google.com/store/apps/details?id=tv.brunstad.app"
                            ><img src="/badges/google_play.png"
                        /></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { mdToHTML } from "@/services/converter"
import { useCookies } from "@/services/cookies"

const { accepted } = useCookies()
</script>
<style>
#footer-description > p > a {
    cursor: pointer;
    color: var(--color-tint-1);
}
#footer-description > p > a:hover {
    text-decoration: underline;
}
</style>
