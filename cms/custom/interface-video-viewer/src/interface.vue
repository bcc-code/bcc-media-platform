<template>
	<div>
		<input :value="value" @input="handleChange($event.target?.value)" />
		<div>
			<Suspense>
				<template #default>
					<media-controller>
						<video slot="media" :src="value">
						</video>
						<media-control-bar>
							<media-play-button></media-play-button>
							<media-mute-button></media-mute-button>
							<media-volume-range></media-volume-range>
							<media-time-range></media-time-range>
							<media-pip-button></media-pip-button>
							<media-fullscreen-button></media-fullscreen-button>
						</media-control-bar>
					</media-controller>
				</template>
				<template #fallback>
					Loading...
				</template>
			</Suspense>
		</div>
	</div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

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
    }
});
</script>
