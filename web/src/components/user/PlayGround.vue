<script lang="ts" setup>
import {
    ref,
    computed,
    onMounted,
    watchEffect,
    reactive,
    toRef,
    toRefs,
} from "vue"
import SearchInput from "../SearchInput.vue"
import NavLink from "../navbar/NavLink.vue"
import { SearchIcon } from "../icons"
import { useI18n } from "vue-i18n"
import { useSearch } from "@/utils/search"
import {
    Disclosure,
    Menu,
    MenuButton,
    MenuItems,
    MenuItem,
    Popover,
    PopoverButton,
    PopoverPanel,
} from "@headlessui/vue"
import HelloWorld from "./HelloWorld.vue"

const { query } = useSearch()
const { t } = useI18n()

const isExactActive = ref(false)
const input = ref<HTMLInputElement | null>(null)
const child = ref<null>(null)

const cube = reactive({
    length: 30,
    width: 20,
    height: 10,
})
const length1 = toRef(cube, "length")
const { length, width, height } = toRefs(cube)

onMounted(() => {
    input.value?.focus()
})

// watchEffect(() =>{
//   if(input.value) {
//     input.value.focus()
//   } else {
//     // not mounted yet, or the element was unmounted (e.g. by v-if)
//   }
// })

// watchEffect(
//   () => {
//     input.value?.focus();
//   },
//   {
//     flush: "post"//this will make watchEffect run after our component updates
//   }
// )

const handleClick = () => {
    child.value
}
// const props = defineProps<{
// }>()
</script>

<template>
    <HelloWorld ref="child" @click="handleClick" />
    <input ref="input" />

    <!--<Popover>
   <PopoverButton>Solutions</PopoverButton>

    <transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="translate-y-1 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="translate-y-1 opacity-0"
    >
      <PopoverPanel>
      </PopoverPanel>
    </transition>
  </Popover> -->
    <Disclosure>
        <div>
            <DisclosureButton>
                <NavLink
                    :icon="SearchIcon"
                    :to="{ name: 'search' }"
                    @click="isExactActive = true"
                    v-if="!isExactActive"
                >
                    {{ t("page.search") }}
                </NavLink>
            </DisclosureButton>

            <DisclosurePanel>
                <SearchInput
                    v-if="isExactActive"
                    class="ml-6 my-auto space-x-2"
                    v-model="query"
                    @keydown="
                        $route.name !== 'search'
                            ? $router.push({ name: 'search' })
                            : null
                    "
                ></SearchInput>
            </DisclosurePanel>
        </div>
    </Disclosure>
</template>

<style sc></style>
