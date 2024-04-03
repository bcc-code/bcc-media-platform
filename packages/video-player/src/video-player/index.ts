import videojs, { VideoJsPlayer, VideoJsPlayerOptions } from "video.js"
import "video.js/dist/video-js.css"
import "videojs-contrib-quality-levels"
import "videojs-event-tracking"
import "videojs-mux"
import { enableNPAW, Options as NPAWOptions, setOptions } from "./npaw"

// External plugins
import { CastLoader } from "./utils"
import registerChromecastPlugin from "@silvermine/videojs-chromecast"
import hlsQualitySelector from "@/../external-projects/videojs-hls-quality-selector/src/plugin"

// Internal plugins/extensions
import "./plugins/videojs-smallscreen"
import "./plugins/smooth-seek"
import { SeekForwardButton, SeekBackwardButton } from "./plugins/seek-buttons"
import { DismissControlBarButton } from "./plugins/smart-tv"
import "./skin/style.scss"
import { isSmartTV } from "./utils/userAgent"

if (!videojs.getPlugin("hlsQualitySelector")) {
    // needed for demo. I don't understand why because it does the exact same as videojs-contrib-quality-levels.
    videojs.registerPlugin("hlsQualitySelector", hlsQualitySelector)
}

let castLoaded = false;

CastLoader.load().then(() => {
    registerChromecastPlugin(videojs, undefined)
    castLoaded = true
})

export type Player = VideoJsPlayer

export async function createPlayer(containerId: string, opts: Partial<Options>): Promise<Player> {
    if (!castLoaded) {
        await new Promise(r => setTimeout(r, 100))
    }

    const options = videojs.mergeOptions(getDefaults(), opts)

    const videoElId = "videojs-" + containerId
    var existingPlayer = videojs.getPlayer(videoElId)
    if (existingPlayer) {
        existingPlayer.dispose()
    }
    const videoEl = createVideoElement(videoElId, options)

    document.getElementById(containerId)?.insertAdjacentElement("afterbegin", videoEl)

    const player = setupVideoJs(videoEl, options)
    if (options.npaw?.enabled === true) {
        enableNPAW(player, options.npaw)
    }

    return player
}

export type Options = {
    src: {
        type?: "application/x-mpegURL" | string,
        src?: string
    },
    languagePreferenceDefaults: {
        audio?: string,
        subtitles?: string,
    },
    npaw?: NPAWOptions,
    autoplay: boolean,
    subtitles: any[],
    videojs: VideoJsPlayerOptions
}

const getDefaults = () => {
    const plugins: {
        [key: string]: any
    } = {
        eventTracking: true,
        smallScreen: {},
    };

    if (castLoaded) {
        plugins.chromecast = {
            buttonPositionIndex: 10,
            receiverAppID: "BC91FA3B", // BEE6F0D4 for debug
        }
    }

    return {
        src: {
            type: "application/x-mpegURL",
        },
        autoplay: false,
        languagePreferenceDefaults: {},
        subtitles: [],
        videojs: {
            autoplay: false,
            controls: true,
            fluid: true,
            crossOrigin: "anonymous",
            html5: {
                vhs: {
                    experimentalBufferBasedABR: false, // will soon be default (https://github.com/videojs/http-streaming/issues/1112#issuecomment-821290575)
                    useBandwidthFromLocalStorage: true,
                    overrideNative: true,
                    limitRenditionByPlayerDimensions: true,
                    useDevicePixelRatio: true,
                    allowSeeksWithinUnsafeLiveWindow: true,
                    cacheEncryptionKeys: true, // TODO: remove this and fix caching headers. https://github.com/videojs/video.js/issues/6106#issuecomment-513304282
                },
                nativeAudioTracks: false,
                nativeVideoTracks: false,
            },
            inactivityTimeout: isSmartTV() ? 60000 : 2000,
            liveui: true,
            liveTracker: {
                trackingThreshold: 15, // default is 30, had issues because occassionally liveWindow is 29.97.
            },
            plugins,
            responsive: true,
            techOrder: castLoaded ? ["chromecast", "html5"] : ["html5"],
            userActions: {
                hotkeys: true,
            },
        },
    } as Options
}

export function setNPAWOptions(player: Player, options: NPAWOptions) {
    setOptions(player, options)
}

function createVideoElement(id: string, options: Options) {
    const videoEl = document.createElement("video")
    videoEl.classList.add("video-js", "vjs-brunstadtv-skin")
    if (options.autoplay) {
        videoEl.classList.add("vjs-show-startup-spinner")
    }
    videoEl.id = id
    return videoEl
}

function setAudioTrackToLanguage(player: VideoJsPlayer, language?: string) {
    let track = null as videojs.VideojsAudioTrack | null

    for (const t of Object.values((player.audioTracks() as unknown as { tracks_: any[] }).tracks_)) {
        if (t.language === language) {
            track = t
        }
    }

    if (language && track) {
        track.enabled = true
    }
}

function setSubtitleTrackToLanguage(player: VideoJsPlayer, language?: string) {
    const tracks = Object.values(player
        .remoteTextTracks()
    )?.filter((t) => t.kind === "captions" || t.kind === "subtitles")
    const track = tracks.find((t) => t.language?.substr(0, 3) === language)
    tracks.forEach(
        (t) => (t.mode = track && track.id === t.id ? "showing" : "hidden")
    )
}

function setupVideoJs(videoElId: Element, options: Options) {
    const player = videojs(videoElId, options.videojs)
    player.src(options.src as any)

    if (options.subtitles) {
        for (var x = 0; x < options.subtitles.length; x++) {
            player.addRemoteTextTrack(options.subtitles[x], false)
        }
    }

    player.ready(function () {
        // var seekTo = getQueryVariable("t")
        // if (seekTo) player.currentTime(parseInt(seekTo))

        player.controlBar.addChild(new SeekForwardButton(player), {}, 1)
        player.controlBar.addChild(new SeekBackwardButton(player), {}, 0)
        if (isSmartTV()) {
            player.controlBar.addChild(
                new DismissControlBarButton(player),
                {},
                99
            )
        }

        (player as any).hlsQualitySelector()

        var sl = (player.tech({ IWillNotUseThisInPlugins: true }) as any).vhs
            ?.masterPlaylistController_?.mainSegmentLoader_
        if (sl) {
            sl.on("error", function () {
                let error = sl.error()
                if (!error || (error.status !== 401 && error.status !== 403))
                    return
                player.pause()
                player.error(
                    "Session possibly expired. Try reloading the page to continue watching."
                )
                player.errorDisplay.show()
                player.reset()
            })
        }
    })

    player.one("loadedmetadata", () => {
        setAudioTrackToLanguage(
            player,
            options.languagePreferenceDefaults.audio
        )
        setSubtitleTrackToLanguage(
            player,
            options.languagePreferenceDefaults.subtitles
        )
    })

    const p = player as any

    p.setAudioTrackToLanguage = function (language: string) {
        setAudioTrackToLanguage(this, language)
    }
    p.setSubtitleTrackToLanguage = function (language: string) {
        setSubtitleTrackToLanguage(this, language)
    }
    p.setVideoQuality = (height: any) => {
        videojs.log("BTV: Queued setting quality to " + height + "p")
        p.ready(() => {
            if (
                typeof p.hlsQualitySelector !== "object" ||
                !p.qualityLevels() ||
                !p.qualityLevels().levels_ ||
                p.qualityLevels().levels_.length < 1
            ) {
                videojs.log("BTV: Can't change quality yet.")
                return
            }
            videojs.log("BTV: Setting quality to " + height + "p")
            return p.hlsQualitySelector.setQuality(height)
        })
    }

    return player
}
