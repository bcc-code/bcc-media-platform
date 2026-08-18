// Ejected from @videojs/html/video/minimal-skin. Building the DOM in light
// DOM is what lets us add custom controls without subclassing the skin or
// reaching into shadow DOM.

import { isSmartTV } from "../utils/userAgent"
import { getTrackLanguageName, type Lang, relabelSkin } from "../i18n/strings"

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
import ICON_CAPTIONS_OFF from "./icons/captions-off.svg?raw"
import ICON_QUALITY from "./icons/quality.svg?raw"
import ICON_LANGUAGE from "./icons/language.svg?raw"
import ICON_CHEVRON from "./icons/chevron.svg?raw"
import ICON_SPEED from "./icons/speed.svg?raw"
import ICON_CAST_ENTER from "./icons/cast-enter.svg?raw"
import ICON_CAST_EXIT from "./icons/cast-exit.svg?raw"
import ICON_AIRPLAY_ENTER from "./icons/airplay-enter.svg?raw"
import ICON_AIRPLAY_EXIT from "./icons/airplay-exit.svg?raw"
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
    // commandfor / popovertarget resolve against the first matching ID in the
    // document, so two players on a page would share each other's popovers.
    const sid = ++skinIdSeq
    const ID_PLAY = `play-tooltip-${sid}`
    const ID_SEEK_BACK = `seek-backward-tooltip-${sid}`
    const ID_SEEK_FWD = `seek-forward-tooltip-${sid}`
    const ID_VOLUME = `video-volume-popover-${sid}`
    const ID_PIP = `pip-tooltip-${sid}`
    const ID_FS = `fullscreen-tooltip-${sid}`
    const ID_CAST = `cast-tooltip-${sid}`
    const ID_AIRPLAY = `airplay-tooltip-${sid}`
    const ID_AUDIO_MENU = `audio-menu-${sid}`
    const ID_SUBS_MENU = `subs-menu-${sid}`
    const ID_QUALITY_MENU = `quality-menu-${sid}`
    const ID_SETTINGS = `settings-tooltip-${sid}`
    const ID_SETTINGS_MENU = `settings-menu-${sid}`
    const ID_RATE_MENU = `rate-menu-${sid}`
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

    // Touch-only centered playback cluster. The skin CSS swaps this in for the
    // bottom bar's playback group on coarse pointers, so only one is ever
    // visible; both bind the same player state via context.
    const centerControls = `
      <div class="bccm-center-controls">
        <media-seek-button seconds="${-SEEK_TIME}" class="media-button media-button--subtle media-button--icon media-button--seek bccm-center-button">
          <span class="media-icon__container">
            ${ICON_SEEK_FLIPPED}<span class="media-icon__label">${SEEK_TIME}</span>
          </span>
        </media-seek-button>
        <media-play-button class="media-button media-button--subtle media-button--icon media-button--play bccm-center-button bccm-center-button--play">
          ${ICON_RESTART}${ICON_PLAY}${ICON_PAUSE}
        </media-play-button>
        <media-seek-button seconds="${SEEK_TIME}" class="media-button media-button--subtle media-button--icon media-button--seek bccm-center-button">
          <span class="media-icon__container">
            ${ICON_SEEK}<span class="media-icon__label">${SEEK_TIME}</span>
          </span>
        </media-seek-button>
      </div>`

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

            <bccm-settings-trigger commandfor="${ID_SETTINGS}" menu="${ID_SETTINGS_MENU}"></bccm-settings-trigger>
            <media-tooltip id="${ID_SETTINGS}" side="top" class="media-tooltip"><span data-i18n="settings"></span></media-tooltip>
            <media-menu id="${ID_SETTINGS_MENU}" side="top" align="center" class="media-popover bccm-menu bccm-menu--settings">
              <div class="bccm-menu__group">
                <media-menu-item commandfor="${ID_QUALITY_MENU}" class="bccm-menu__item bccm-menu__item--submenu">
                  ${ICON_QUALITY}<span data-i18n="quality"></span>
                  <span class="bccm-menu__hint"><span data-part="hint" class="bccm-menu__hint-label"></span>${ICON_CHEVRON}</span>
                </media-menu-item>
                <media-menu-item commandfor="${ID_AUDIO_MENU}" class="bccm-menu__item bccm-menu__item--submenu">
                  ${ICON_LANGUAGE}<span data-i18n="audio"></span>
                  <span class="bccm-menu__hint"><span data-part="hint" class="bccm-menu__hint-label"></span>${ICON_CHEVRON}</span>
                </media-menu-item>
                <media-menu-item commandfor="${ID_SUBS_MENU}" class="bccm-menu__item bccm-menu__item--submenu">
                  ${ICON_CAPTIONS_OFF}<span data-i18n="subtitles"></span>
                  <span class="bccm-menu__hint"><span data-part="hint" class="bccm-menu__hint-label"></span>${ICON_CHEVRON}</span>
                </media-menu-item>
                ${
                    live
                        ? ""
                        : `<media-menu-item commandfor="${ID_RATE_MENU}" class="bccm-menu__item bccm-menu__item--submenu">
                  ${ICON_SPEED}<span data-i18n="playbackSpeed"></span>
                  <span class="bccm-menu__hint"><span data-part="hint" class="bccm-menu__hint-label"></span>${ICON_CHEVRON}</span>
                </media-menu-item>`
                }
              </div>
              <media-menu id="${ID_QUALITY_MENU}" class="bccm-menu__panel">
                <media-menu-item class="bccm-menu__item bccm-menu__back">${ICON_CHEVRON}<span data-i18n="quality"></span></media-menu-item>
                <div class="bccm-menu__separator"></div>
                <media-quality-radio-group class="bccm-menu__group">
                  <template>
                    <media-menu-radio-item class="bccm-menu__item"><span><span data-part="label"></span><sup data-part="tier" class="bccm-menu__tier" hidden></sup></span><span data-part="badge" class="bccm-menu__badge" hidden></span></media-menu-radio-item>
                  </template>
                </media-quality-radio-group>
              </media-menu>
              <media-menu id="${ID_AUDIO_MENU}" class="bccm-menu__panel">
                <media-menu-item class="bccm-menu__item bccm-menu__back">${ICON_CHEVRON}<span data-i18n="audio"></span></media-menu-item>
                <div class="bccm-menu__separator"></div>
                <media-audio-track-radio-group class="bccm-menu__group">
                  <template>
                    <media-menu-radio-item class="bccm-menu__item"><span data-part="label"></span></media-menu-radio-item>
                  </template>
                </media-audio-track-radio-group>
              </media-menu>
              ${
                  live
                      ? ""
                      : `<media-menu id="${ID_RATE_MENU}" class="bccm-menu__panel">
                <media-menu-item class="bccm-menu__item bccm-menu__back">${ICON_CHEVRON}<span data-i18n="playbackSpeed"></span></media-menu-item>
                <div class="bccm-menu__separator"></div>
                <media-playback-rate-radio-group class="bccm-menu__group">
                  <template>
                    <media-menu-radio-item class="bccm-menu__item"><span data-part="label"></span></media-menu-radio-item>
                  </template>
                </media-playback-rate-radio-group>
              </media-menu>`
              }
              <media-menu id="${ID_SUBS_MENU}" class="bccm-menu__panel">
                <media-menu-item class="bccm-menu__item bccm-menu__back">${ICON_CHEVRON}<span data-i18n="subtitles"></span></media-menu-item>
                <div class="bccm-menu__separator"></div>
                <media-captions-radio-group class="bccm-menu__group">
                  <template>
                    <media-menu-radio-item class="bccm-menu__item"><span data-part="label"></span></media-menu-radio-item>
                  </template>
                </media-captions-radio-group>
              </media-menu>
            </media-menu>

            <media-cast-button commandfor="${ID_CAST}" class="media-button media-button--subtle media-button--icon media-button--cast">
              ${ICON_CAST_ENTER}${ICON_CAST_EXIT}
            </media-cast-button>
            <media-tooltip id="${ID_CAST}" side="top" class="media-tooltip"></media-tooltip>

            <media-airplay-button commandfor="${ID_AIRPLAY}" class="media-button media-button--subtle media-button--icon media-button--airplay">
              ${ICON_AIRPLAY_ENTER}${ICON_AIRPLAY_EXIT}
            </media-airplay-button>
            <media-tooltip id="${ID_AIRPLAY}" side="top" class="media-tooltip"></media-tooltip>

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

      ${centerControls}

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

    // Media element first — the skin CSS stacks the overlays on source order.
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

    // Core's radio groups default to the manifest's own track label; we prefer
    // the language's native name ("Norsk"), same as the triggers.
    type TrackLike = { label: string; language: string }
    type Formattable = Element & { formatTrack?: (t: TrackLike) => string }
    for (const selector of [
        "media-audio-track-radio-group",
        "media-captions-radio-group",
    ]) {
        const group = container.querySelector<Formattable>(selector)
        if (group) {
            group.formatTrack = (track) =>
                getTrackLanguageName(track.language) ||
                track.label ||
                track.language
        }
    }

    // Core formats rates bare ("1"); we want the multiplier.
    const rates = container.querySelector<
        Element & { formatRate?: (rate: number) => string }
    >("media-playback-rate-radio-group")
    if (rates) {
        rates.formatRate = (rate) =>
            `${Number.isInteger(rate) ? rate : rate.toString()}×`
    }

    relabelSkin(container, options.language ?? "en")

    return container
}
