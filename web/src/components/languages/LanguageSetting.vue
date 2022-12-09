<script lang="ts" setup>
import { PopoverButton, Popover, PopoverPanel, PopoverOverlay } from "@headlessui/vue"
import { current, languages, getNestedLangComputed, setNestedLangMethod } from "@/services/language"
import { ref } from "vue"

const selectedTitle = ref('')
const isMenuActive = ref(true)

defineProps<{ open: boolean }>()

const data = [
	"site", "audio", "subtitle"
]

const toPages = (title: string): void => {
	selectedTitle.value = title;
	isMenuActive.value = !isMenuActive.value
}

const toMenu = (code: string): void => {
	setNestedLangMethod(selectedTitle.value, code)
	isMenuActive.value = !isMenuActive.value
}

const getLanguage = (code: string) => {
	return languages.value.find((item) => item.code == code)
}

</script>

<template>

	<Popover v-slot="{ open }">
		<PopoverButton
			@click="isMenuActive=true"
			class="flex hover:bg-slate-800 transition rounded-full text-base px-2 p-1 font-medium text-white hover:text-opacity-100 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
			<svg width="24" height="24" viewBox="0 0 24 24" fill="none" class="w-8 h-8 fill-primary"
				xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd"
					d="M12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2ZM4.25203 10C4.08751 10.6392 4 11.3094 4 12C4 12.6906 4.08751 13.3608 4.25203 14H7.09432C7.03228 13.3521 7 12.6829 7 12C7 11.3171 7.03228 10.6479 7.09432 10H4.25203ZM5.07026 8H7.39317C7.60515 6.9765 7.89762 6.04022 8.25776 5.2299C8.31802 5.09431 8.38064 4.96122 8.44561 4.83099C7.03292 5.53275 5.8571 6.63979 5.07026 8ZM9.10446 10C9.03652 10.6376 9 11.3072 9 12C9 12.6928 9.03652 13.3624 9.10446 14H14.8955C14.9635 13.3624 15 12.6928 15 12C15 11.3072 14.9635 10.6376 14.8955 10H9.10446ZM14.5584 8H9.44164C9.61531 7.26765 9.83379 6.60826 10.0854 6.04218C10.4134 5.30422 10.778 4.76892 11.1324 4.43166C11.4816 4.0993 11.7731 4 12 4C12.2269 4 12.5184 4.0993 12.8676 4.43166C13.222 4.76892 13.5866 5.30422 13.9146 6.04218C14.1662 6.60826 14.3847 7.26765 14.5584 8ZM16.9057 10C16.9677 10.6479 17 11.3171 17 12C17 12.6829 16.9677 13.3521 16.9057 14H19.748C19.9125 13.3608 20 12.6906 20 12C20 11.3094 19.9125 10.6392 19.748 10H16.9057ZM18.9297 8H16.6068C16.3949 6.9765 16.1024 6.04022 15.7422 5.2299C15.682 5.09431 15.6194 4.96122 15.5544 4.83099C16.9671 5.53275 18.1429 6.63979 18.9297 8ZM8.44561 19.169C7.03292 18.4672 5.85709 17.3602 5.07026 16H7.39317C7.60515 17.0235 7.89762 17.9598 8.25776 18.7701C8.31802 18.9057 8.38064 19.0388 8.44561 19.169ZM10.0854 17.9578C9.83379 17.3917 9.61531 16.7324 9.44164 16H14.5584C14.3847 16.7324 14.1662 17.3917 13.9146 17.9578C13.5866 18.6958 13.222 19.2311 12.8676 19.5683C12.5184 19.9007 12.2269 20 12 20C11.7731 20 11.4816 19.9007 11.1324 19.5683C10.778 19.2311 10.4134 18.6958 10.0854 17.9578ZM15.7422 18.7701C16.1024 17.9598 16.3949 17.0235 16.6068 16H18.9297C18.1429 17.3602 16.9671 18.4672 15.5544 19.169C15.6194 19.0388 15.682 18.9057 15.7422 18.7701Z" />
			</svg>
			<span class="uppercase ml-1 my-auto">{{current.code}}</span>
		</PopoverButton>
		<PopoverOverlay class="fixed inset-0 bg-black opacity-40" />
		<transition 
			enter-active-class="transition duration-200 ease-out"
			enter-from-class="translate-y-1 opacity-0"
			enter-to-class="translate-y-0 opacity-100"
			leave-active-class="transition duration-150 ease-in"
			leave-from-class="translate-y-0 opacity-100"
			leave-to-class="translate-y-1 opacity-0">
			<PopoverPanel class="absolute z-10 mt-3 w-52 sm:w-96 sm:-translate-x-64 -translate-x-1/2  px-4 sm:px-0">
				
				<div class="bg-slate-700 rounded-md relative bg-white p-2.5 sm:p-5 text-black  ">
					<button v-show="!isMenuActive" @click="isMenuActive=!isMenuActive" class="sm:absolute sm:left-5 sm:top-[20px] mb-1 sm:mb-0 rounded-[5px] hover:rounded-lg hover:bg-white-100 text-[#6EB0E6] font-bold">&#60 Back</button>
					<div class="flex justify-center text-xl font-bold text-white mb-2">{{ isMenuActive ? $t("language.language") : $t('language.'+selectedTitle)}}</div>
					<section v-show="isMenuActive">
						<div class="mx-4 my-2 text-xs text-[#EBEBF599]">{{ $t("language.language") }}</div>
						<div v-for="el in data">
							<button @click="toPages(el)"
								class="hover:bg-[#EBEBF599] hover:text-white text-gray-900 bg-[#1D2838] w-full px-4 py-[16px] text-sm transition duration-50 cursor-pointer flow-root"
								:class="data.indexOf(el)==0 ? 'rounded-t-lg' : data.indexOf(el)==data.length-1 ? 'rounded-b-lg' : ''"
								>
								<div class="text-white float-left ">{{ $t("language."+el) }}</div>
								<div class="text-[#EBEBF599] float-right">
									<span>{{ getNestedLangComputed(el).name }}</span>
									<span v-if="current.code!='en'">&ensp;({{ getNestedLangComputed(el).english }})</span>
								</div>
							</button>
						</div>
					</section>
					
					<section v-show="!isMenuActive">
						<div v-for="item in languages">
							<button @click="toMenu(item.code)" 
								class="hover:bg-[#EBEBF599] hover:text-white text-gray-900 bg-[#1D2838] w-full px-4 py-[16px] text-sm transition duration-50 cursor-pointer flow-root" 
								:class="(languages.indexOf(item)==0) ? 'rounded-t-lg' : languages.indexOf(item)==languages.length-1 ? 'rounded-b-lg' : ''">
								<div class="text-white float-left">
									<div class="text-[17px] font-bold text-left">{{ item.name }}</div>
									<div v-show="current.code!='en'" class=" mt-[2px] text-[#EBEBF599] text-xs text-left">{{getLanguage(item.code)?.english}}</div>
								</div>
								<div class="text-[#EBEBF599] flex justify-end" :class="current.code!='en' ? 'my-3' : 'py-1'" v-show="item.code == getNestedLangComputed(selectedTitle)?.code"> &#9745</div>
							</button>
						</div>
					</section>
				</div>
			</PopoverPanel>
		</transition>
	</Popover>
</template>