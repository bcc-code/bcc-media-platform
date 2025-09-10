<script setup lang="ts">
import type { StreamFragment } from "#gql";
import { StreamType } from "#gql/default";
import type { Player, Options } from "bccm-video-player";
import { createVjsMenuButton, type MenuItem } from "~/utils/videojs/Menu";
import "bccm-video-player/css";

const route = useRoute();

const props = defineProps<{
  episode: {
    id: string;
    uuid: string;
    title: string;
    originalTitle: string;
    duration: number;
    progress?: number | null;
    season?: {
      id: string;
      title: string;
      show: {
        id: string;
        title: string;
      };
    } | null;
    streams: StreamFragment[];
  };
  autoPlay?: boolean;
}>();

const { data: me, execute } = useAsyncGql({
  operation: "getMe",
});

const player = ref<Player | null>(null);
const current = ref<string>();

const loaded = ref(false);

const { authenticated } = useAuth();
const { $playerFactory } = useNuxtApp();

const load = async () => {
  const episodeId = props.episode.uuid;
  const referenceId = generateUUID();
  if (current.value !== episodeId) {
    loaded.value = false;
    current.value = episodeId;
    if (!me.value) {
      await execute();
    }

    const options: Partial<Options> = {
      // languagePreferenceDefaults: {
      //   audio: languageTo3letter(currentLanguage.value.code),
      //   subtitles: languageTo3letter(currentLanguage.value.code),
      // },
      videojs: {
        autoplay: props.autoPlay,
        playbackRates: [0.75, 1, 1.5, 1.75, 2],
        aspectRatio: "16:9",
      },
      // onProgress(currentTime, duration, player) {
      //   onVideoProgress(currentTime, duration, player);
      // },
      // npaw: {
      //   enabled: !!import.meta.env.VITE_NPAW_ACCOUNT_CODE,
      //   accountCode: import.meta.env.VITE_NPAW_ACCOUNT_CODE,
      //   appName: currentApp.value,
      //   tracking: {
      //     isLive: false,
      //     userId: data.value?.me.analytics.anonymousId,
      //     sessionId: getSessionId()?.toString() ?? undefined,
      //     ageGroup: analytics.getUser()?.ageGroup,
      //     metadata: {
      //       contentId: props.episode.id,
      //       title: props.episode.originalTitle,
      //       seasonTitle: props.episode.season?.title,
      //       seasonId: props.episode.season?.id,
      //       showTitle: props.episode.season?.show.title,
      //       showId: props.episode.season?.show.id,
      //       overrides: {
      //         "content.language": languageTo3letter(currentLanguage.value.code),
      //         "content.subtitles": languageTo3letter(
      //           currentLanguage.value.code
      //         ),
      //         "content.transactionCode": referenceId,
      //       },
      //     },
      //   },
      // },
    };

    player.value?.dispose();
    player.value = await $playerFactory.create("video-player", {
      episodeId: episodeId,
      videoLanguage: route.query.videoLang as string | undefined,
      overrides: options,
    });

    if (player.value == null) {
      return;
    }
    setupVideoLanguageMenu(player.value as Player);

    // create a event when player is created
    const vodPlayer = new CustomEvent("vodPlayer", {
      detail: player.value,
      bubbles: false,
      cancelable: true,
      composed: false,
    });
    window.dispatchEvent(vodPlayer);

    // lastProgress = props.episode.progress;
    // const queryTime = parseInt(route.query.t as string, 10);
    // const seekTo = queryTime ?? lastProgress;
    // if (seekTo && !isNaN(seekTo)) {
    //   player.value.currentTime(seekTo);
    // }

    // if (authenticated()) {
    //   player.value.on("timeupdate", checkProgress);
    // }
    // player.value.on("ended", () => {
    //   emit("next");
    // });
    // player.value.on("play", () => {
    //   analytics.track("video_played", {
    //     videoId: props.episode.id,
    //     referenceId: referenceId,
    //     data: {
    //       // Whatever data we want to send
    //     },
    //   });
    // });
    loaded.value = true;
  }
};

onMounted(load);
onUpdated(load);

const setupVideoLanguageMenu = (player: Player) => {
  const videoLanguages = props.episode.streams
    .filter((s) => s.type === StreamType.Hls_cmaf)
    .map((s) => {
      if (s.videoLanguage === null) {
        return {
          label: "Original",
          value: null,
          selected: route.query.videoLang == null,
        };
      }
      return {
        label: languages.value.filter((l) => l.code === s.videoLanguage)[0]
          .localizedName,
        value: s.videoLanguage,
        selected: route.query.videoLang === s.videoLanguage,
      } as MenuItem;
    });

  function setVideoLanguage(lang: string | undefined) {
    let url = `?t=${player.currentTime()}`;
    if (lang) {
      url += `&videoLang=${lang}`;
    }
    window.location.href = url;
  }

  createVjsMenuButton(player, {
    items: videoLanguages,
    icon: "vjs-icon-subtitles",
    title: "Video Language",
    id: "videolanguage",
    placement: 10,
    onClick: (i) => setVideoLanguage(i.value),
  });
};

// Keyboard controls
const doTogglePlay = () => {
  if (!player.value) return;
  if (player.value.paused()) {
    player.value.play();
  } else {
    player.value.pause();
  }
};
const doPlayerSkip = (seconds: number) => {
  const currentTime = player.value?.currentTime();
  if (!player.value || !currentTime) return;
  player.value.currentTime(currentTime + seconds);
};
const onKeyDown = (event: KeyboardEvent) => {
  if (!player.value) return;
  if (event.type === "keydown") {
    switch (event.key) {
      case " ":
      case "k":
        event.preventDefault();
        doTogglePlay();
        break;
      case "ArrowLeft":
        event.preventDefault();
        doPlayerSkip(-5);
        break;
      case "ArrowRight":
        event.preventDefault();
        doPlayerSkip(5);
        break;
      case "j":
        event.preventDefault();
        doPlayerSkip(-10);
        break;
      case "l":
        event.preventDefault();
        doPlayerSkip(10);
        break;
    }
  }
};
useEventListener("keydown", onKeyDown);

defineExpose({
  player,
});
</script>

<template>
  <div
    id="video-player"
    :class="[
      'aspect-video bg-background-2 border-b border-separator-on-light transition-opacity duration-700 ease-out-expo',
      loaded ? 'opacity-100' : 'opacity-0',
    ]"
  />
</template>
