// Ejected from @videojs/html/video/minimal-skin per the "Customize skins"
// guide. Composing the DOM in light DOM lets us insert custom controls into
// the bottom button group without subclassing the skin or reaching into
// shadow DOM. Icons live as .svg files under ./icons and are inlined into
// innerHTML via Vite's ?raw imports — the media-icon--* classes on each SVG
// drive the skin CSS's state toggling.

import { isSmartTV } from "../utils/userAgent"
import { type Lang, relabelSkin } from "../i18n/strings"
import { installButtonLabels } from "../i18n/button-labels"

import ICON_RESTART from "./icons/restart.svg?raw"
import ICON_PLAY from "./icons/play.svg?raw"
import ICON_PAUSE from "./icons/pause.svg?raw"
import ICON_SEEK from "./icons/seek.svg?raw"
import ICON_SEEK_FLIPPED from "./icons/seek-flipped.svg?raw"
import ICON_VOLUME_OFF from "./icons/volume-off.svg?raw"
import ICON_VOLUME_LOW from "./icons/volume-low.svg?raw"
import ICON_VOLUME_HIGH from "./icons/volume-high.svg?raw"
import ICON_PIP_ENTER from "./icons/pip-enter.svg?raw"
import ICON_PIP_EXIT from "./icons/pip-exit.svg?raw"
import ICON_FS_ENTER from "./icons/fullscreen-enter.svg?raw"
import ICON_FS_EXIT from "./icons/fullscreen-exit.svg?raw"
import ICON_CAST_ENTER from "./icons/cast-enter.svg?raw"
import ICON_CAST_EXIT from "./icons/cast-exit.svg?raw"
import ICON_SPINNER from "./icons/spinner.svg?raw"

const SEEK_TIME = 15
let skinIdSeq = 0

const ICON_SPINNER_PREVIEW = ICON_SPINNER.replace(
    'class="media-icon"',
    'class="media-preview__spinner media-icon"'
)

export interface SkinOptions {
    poster?: string
    live?: boolean
    language?: Lang
}

export function buildSkin(
    media: HTMLElement,
    options: SkinOptions
): HTMLElement {
    const container = document.createElement("media-container")
    container.className = "media-minimal-skin media-minimal-skin--video"

    const live = options.live === true
    // Each skin instance needs unique IDs for tooltip / popover targets.
    // commandfor / popovertarget look up the first matching ID in the document,
    // so two players on the same page would otherwise share the VOD player's
    // volume popover and tooltips.
    const sid = ++skinIdSeq
    const ID_PLAY = `play-tooltip-${sid}`
    const ID_SEEK_BACK = `seek-backward-tooltip-${sid}`
    const ID_SEEK_FWD = `seek-forward-tooltip-${sid}`
    const ID_VOLUME = `video-volume-popover-${sid}`
    const ID_PIP = `pip-tooltip-${sid}`
    const ID_FS = `fullscreen-tooltip-${sid}`
    const ID_CAST = `cast-tooltip-${sid}`
    const ID_RATE = `rate-tooltip-${sid}`
    const ID_AUDIO = `audio-tooltip-${sid}`
    const ID_SUBS = `subtitles-tooltip-${sid}`
    const ID_QUALITY = `quality-tooltip-${sid}`
    const ID_LIVE = `live-tooltip-${sid}`
    const ID_DISMISS = `dismiss-tooltip-${sid}`

    // The live and VOD skins share nearly everything — only the right-hand
    // side of the time controls differs (LIVE badge vs duration display).
    const leftButtons = `<media-play-button commandfor="${ID_PLAY}" class="media-button media-button--subtle media-button--icon media-button--play">
              ${ICON_RESTART}${ICON_PLAY}${ICON_PAUSE}
            </media-play-button>
            <media-tooltip id="${ID_PLAY}" side="top" class="media-tooltip"></media-tooltip>

            <media-seek-button commandfor="${ID_SEEK_BACK}" seconds="${-SEEK_TIME}" class="media-button media-button--subtle media-button--icon media-button--seek">
              <span class="media-icon__container">
                ${ICON_SEEK_FLIPPED}<span class="media-icon__label">${SEEK_TIME}</span>
              </span>
            </media-seek-button>
            <media-tooltip id="${ID_SEEK_BACK}" side="top" class="media-tooltip"><span data-i18n="seekBackward" data-i18n-params='{"seconds":${SEEK_TIME}}'></span></media-tooltip>

            <media-seek-button commandfor="${ID_SEEK_FWD}" seconds="${SEEK_TIME}" class="media-button media-button--subtle media-button--icon media-button--seek">
              <span class="media-icon__container">
                ${ICON_SEEK}<span class="media-icon__label">${SEEK_TIME}</span>
              </span>
            </media-seek-button>
            <media-tooltip id="${ID_SEEK_FWD}" side="top" class="media-tooltip"><span data-i18n="seekForward" data-i18n-params='{"seconds":${SEEK_TIME}}'></span></media-tooltip>`

    // Current time sits left of the slider; duration (VOD) or the LIVE badge
    // (live) sits to the right.
    const leadingTime = `<media-time type="current" class="media-time media-time--current"></media-time>`

    const trailingTime = live
        ? `<bccm-live-button commandfor="${ID_LIVE}"></bccm-live-button>
            <media-tooltip id="${ID_LIVE}" side="top" class="media-tooltip"><span data-i18n="goToLive"></span></media-tooltip>`
        : `<media-time type="duration" class="media-time media-time--duration"></media-time>`

    const timeControls = `${leadingTime}
            <media-time-slider class="media-slider">
              <media-slider-track class="media-slider__track">
                <media-slider-fill class="media-slider__fill"></media-slider-fill>
                <media-slider-buffer class="media-slider__buffer"></media-slider-buffer>
              </media-slider-track>
              <media-slider-thumb class="media-slider__thumb"></media-slider-thumb>
              <div class="media-preview media-slider__preview">
                <div class="media-preview__thumbnail-wrapper">
                  <media-slider-thumbnail class="media-preview__thumbnail"></media-slider-thumbnail>
                </div>
                <media-slider-value type="pointer" class="media-time media-preview__time"></media-slider-value>
                ${ICON_SPINNER_PREVIEW}
              </div>
            </media-time-slider>
            ${trailingTime}`

    container.innerHTML = `
      <media-poster></media-poster>

      <media-buffering-indicator class="media-buffering-indicator">
        ${ICON_SPINNER}
      </media-buffering-indicator>

      <media-error-dialog class="media-error">
        <div class="media-error__dialog">
          <div class="media-error__content">
            <media-alert-dialog-title class="media-error__title" data-i18n="somethingWentWrong"></media-alert-dialog-title>
            <media-alert-dialog-description class="media-error__description"></media-alert-dialog-description>
          </div>
          <div class="media-error__actions">
            <media-alert-dialog-close class="media-button media-button--primary" data-i18n="ok"></media-alert-dialog-close>
          </div>
        </div>
      </media-error-dialog>

      <media-controls class="media-controls">
        <media-tooltip-group>
          <div class="media-button-group">
            ${leftButtons}
          </div>

          <div class="media-time-controls">
            ${timeControls}
          </div>

          <div class="media-button-group" data-bccm-right-group>
            ${
                live
                    ? ""
                    : `<bccm-playback-rate-picker commandfor="${ID_RATE}"></bccm-playback-rate-picker>
            <media-tooltip id="${ID_RATE}" side="top" class="media-tooltip"><span data-i18n="playbackSpeed"></span></media-tooltip>`
            }

            <media-mute-button commandfor="${ID_VOLUME}" class="media-button media-button--subtle media-button--icon media-button--mute">
              ${ICON_VOLUME_OFF}${ICON_VOLUME_LOW}${ICON_VOLUME_HIGH}
            </media-mute-button>

            <media-popover id="${ID_VOLUME}" open-on-hover delay="200" close-delay="100" side="top" class="media-popover media-popover--volume">
              <media-volume-slider class="media-slider" orientation="vertical" thumb-alignment="edge">
                <media-slider-track class="media-slider__track">
                  <media-slider-fill class="media-slider__fill"></media-slider-fill>
                </media-slider-track>
                <media-slider-thumb class="media-slider__thumb media-slider__thumb--persistent"></media-slider-thumb>
              </media-volume-slider>
            </media-popover>

            <bccm-audio-picker commandfor="${ID_AUDIO}"></bccm-audio-picker>
            <media-tooltip id="${ID_AUDIO}" side="top" class="media-tooltip"><span data-i18n="audio"></span></media-tooltip>

            <bccm-subtitle-picker commandfor="${ID_SUBS}"></bccm-subtitle-picker>
            <media-tooltip id="${ID_SUBS}" side="top" class="media-tooltip"><span data-i18n="subtitles"></span></media-tooltip>

            <bccm-quality-picker commandfor="${ID_QUALITY}"></bccm-quality-picker>
            <media-tooltip id="${ID_QUALITY}" side="top" class="media-tooltip"><span data-i18n="quality"></span></media-tooltip>

            <media-cast-button commandfor="${ID_CAST}" class="media-button media-button--subtle media-button--icon media-button--cast">
              ${ICON_CAST_ENTER}${ICON_CAST_EXIT}
            </media-cast-button>
            <media-tooltip id="${ID_CAST}" side="top" class="media-tooltip"></media-tooltip>

            <media-pip-button commandfor="${ID_PIP}" class="media-button media-button--subtle media-button--icon media-button--pip">
              ${ICON_PIP_ENTER}${ICON_PIP_EXIT}
            </media-pip-button>
            <media-tooltip id="${ID_PIP}" side="top" class="media-tooltip"></media-tooltip>

            <media-fullscreen-button commandfor="${ID_FS}" class="media-button media-button--subtle media-button--icon media-button--fullscreen">
              ${ICON_FS_ENTER}${ICON_FS_EXIT}
            </media-fullscreen-button>
            <media-tooltip id="${ID_FS}" side="top" class="media-tooltip"></media-tooltip>

            ${
                isSmartTV()
                    ? `<bccm-dismiss-controls-button commandfor="${ID_DISMISS}"></bccm-dismiss-controls-button>
            <media-tooltip id="${ID_DISMISS}" side="top" class="media-tooltip"><span data-i18n="hideControls"></span></media-tooltip>`
                    : ""
            }
          </div>
        </media-tooltip-group>
      </media-controls>

      <div class="media-overlay"></div>

      <media-hotkey keys="Space" action="togglePaused"></media-hotkey>
      <media-hotkey keys="k" action="togglePaused"></media-hotkey>
      <media-hotkey keys="m" action="toggleMuted"></media-hotkey>
      <media-hotkey keys="f" action="toggleFullscreen"></media-hotkey>
      <media-hotkey keys="c" action="toggleSubtitles"></media-hotkey>
      <media-hotkey keys="i" action="togglePictureInPicture"></media-hotkey>
      <media-hotkey keys="ArrowUp" action="volumeStep" value="0.05"></media-hotkey>
      <media-hotkey keys="ArrowDown" action="volumeStep" value="-0.05"></media-hotkey>
      <media-hotkey keys="ArrowRight" action="seekStep" value="5"></media-hotkey>
      <media-hotkey keys="ArrowLeft" action="seekStep" value="-5"></media-hotkey>
      <media-hotkey keys="l" action="seekStep" value="10"></media-hotkey>
      <media-hotkey keys="j" action="seekStep" value="-10"></media-hotkey>
      ${
          live
              ? ""
              : `<media-hotkey keys="0-9" action="seekToPercent"></media-hotkey>
      <media-hotkey keys="Home" action="seekToPercent" value="0"></media-hotkey>
      <media-hotkey keys="End" action="seekToPercent" value="100"></media-hotkey>`
      }

      <media-gesture type="tap" action="togglePaused" pointer="mouse" region="center"></media-gesture>
      <media-gesture type="tap" action="toggleControls" pointer="touch"></media-gesture>
      <media-gesture type="doubletap" action="toggleFullscreen" region="center"></media-gesture>
      <media-gesture type="doubletap" action="seekStep" value="-10" region="left"></media-gesture>
      <media-gesture type="doubletap" action="seekStep" value="10" region="right"></media-gesture>
    `

    // Insert the media element first so the buffering indicator / poster
    // overlay correctly. Order matters for z-index/stacking in the skin CSS.
    container.insertAdjacentElement("afterbegin", media)

    if (options.poster) {
        const poster = container.querySelector("media-poster")
        if (poster) {
            const img = document.createElement("img")
            img.src = options.poster
            img.alt = ""
            poster.appendChild(img)
        }
    }

    relabelSkin(container, options.language ?? "en")
    installButtonLabels(container)

    return container
}
