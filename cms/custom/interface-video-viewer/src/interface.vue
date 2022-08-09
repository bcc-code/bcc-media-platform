<template>
	<Suspense>
		<template #default>
			<Viewer></Viewer>
		</template>
		<template #fallback>
			Loading...
		</template>
	</Suspense>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import Viewer from './viewer/Viewer.vue';

export default defineComponent({
    props: {
        value: {
            type: String,
            default: null,
        },
    },
    emits: ["input"],
    setup(props, { emit }) {
        return { handleChange };
        function handleChange(value: string): void {
            emit("input", value);
        }
    },
    components: { Viewer }
});
</script>
