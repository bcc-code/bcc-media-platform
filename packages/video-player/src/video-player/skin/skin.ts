// Ejected from @videojs/html/video/skin (default video skin) per the
// "Customize skins" guide. Composing the DOM in light DOM lets us insert
// custom controls into the bottom button group without subclassing the skin
// or reaching into shadow DOM. Icons are inlined SVG copied from the docs.

import { isSmartTV } from "../utils/userAgent"

const SEEK_TIME = 15
let skinIdSeq = 0

const ICON_RESTART = `<svg class="media-icon media-icon--restart" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M9 17a8 8 0 0 1-8-8h2a6 6 0 1 0 1.287-3.713l1.286 1.286A.25.25 0 0 1 5.396 7H1.25A.25.25 0 0 1 1 6.75V2.604a.25.25 0 0 1 .427-.177l1.438 1.438A8 8 0 1 1 9 17"/><path fill="currentColor" d="m11.61 9.639-3.331 2.07a.826.826 0 0 1-1.15-.266.86.86 0 0 1-.129-.452V6.849C7 6.38 7.374 6 7.834 6c.158 0 .312.045.445.13l3.331 2.071a.858.858 0 0 1 0 1.438"/></svg>`
const ICON_PLAY = `<svg class="media-icon media-icon--play" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="m14.051 10.723-7.985 4.964a1.98 1.98 0 0 1-2.758-.638A2.06 2.06 0 0 1 3 13.964V4.036C3 2.91 3.895 2 5 2c.377 0 .747.109 1.066.313l7.985 4.964a2.057 2.057 0 0 1 .627 2.808c-.16.257-.373.475-.627.637"/></svg>`
const ICON_PAUSE = `<svg class="media-icon media-icon--pause" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><rect width="5" height="14" x="2" y="2" fill="currentColor" rx="1.75"/><rect width="5" height="14" x="11" y="2" fill="currentColor" rx="1.75"/></svg>`
const ICON_SEEK = `<svg class="media-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M1 9c0 2.21.895 4.21 2.343 5.657l1.414-1.414a6 6 0 1 1 8.956-7.956l-1.286 1.286a.25.25 0 0 0 .177.427h4.146a.25.25 0 0 0 .25-.25V2.604a.25.25 0 0 0-.427-.177l-1.438 1.438A8 8 0 0 0 1 9"/></svg>`
const ICON_SEEK_FLIPPED = `<svg class="media-icon media-icon--flipped" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M1 9c0 2.21.895 4.21 2.343 5.657l1.414-1.414a6 6 0 1 1 8.956-7.956l-1.286 1.286a.25.25 0 0 0 .177.427h4.146a.25.25 0 0 0 .25-.25V2.604a.25.25 0 0 0-.427-.177l-1.438 1.438A8 8 0 0 0 1 9"/></svg>`
const ICON_VOLUME_OFF = `<svg class="media-icon media-icon--volume-off" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M.714 6.008h3.072l4.071-3.857c.5-.376 1.143 0 1.143.601V15.28c0 .602-.643.903-1.143.602l-4.071-3.858H.714c-.428 0-.714-.3-.714-.752V6.76c0-.451.286-.752.714-.752M14.5 7.586l-1.768-1.768a1 1 0 1 0-1.414 1.414L13.085 9l-1.767 1.768a1 1 0 0 0 1.414 1.414l1.768-1.768 1.768 1.768a1 1 0 0 0 1.414-1.414L15.914 9l1.768-1.768a1 1 0 0 0-1.414-1.414z"/></svg>`
const ICON_VOLUME_LOW = `<svg class="media-icon media-icon--volume-low" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M.714 6.008h3.072l4.071-3.857c.5-.376 1.143 0 1.143.601V15.28c0 .602-.643.903-1.143.602l-4.071-3.858H.714c-.428 0-.714-.3-.714-.752V6.76c0-.451.286-.752.714-.752m10.568.59a.91.91 0 0 1 0-1.316.91.91 0 0 1 1.316 0c1.203 1.203 1.47 2.216 1.522 3.208q.012.255.011.51c0 1.16-.358 2.733-1.533 3.803a.7.7 0 0 1-.298.156c-.382.106-.873-.011-1.018-.156a.91.91 0 0 1 0-1.316c.57-.57.995-1.551.995-2.487 0-.944-.26-1.667-.995-2.402"/></svg>`
const ICON_VOLUME_HIGH = `<svg class="media-icon media-icon--volume-high" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M15.6 3.3c-.4-.4-1-.4-1.4 0s-.4 1 0 1.4C15.4 5.9 16 7.4 16 9s-.6 3.1-1.8 4.3c-.4.4-.4 1 0 1.4.2.2.5.3.7.3.3 0 .5-.1.7-.3C17.1 13.2 18 11.2 18 9s-.9-4.2-2.4-5.7"/><path fill="currentColor" d="M.714 6.008h3.072l4.071-3.857c.5-.376 1.143 0 1.143.601V15.28c0 .602-.643.903-1.143.602l-4.071-3.858H.714c-.428 0-.714-.3-.714-.752V6.76c0-.451.286-.752.714-.752m10.568.59a.91.91 0 0 1 0-1.316.91.91 0 0 1 1.316 0c1.203 1.203 1.47 2.216 1.522 3.208q.012.255.011.51c0 1.16-.358 2.733-1.533 3.803a.7.7 0 0 1-.298.156c-.382.106-.873-.011-1.018-.156a.91.91 0 0 1 0-1.316c.57-.57.995-1.551.995-2.487 0-.944-.26-1.667-.995-2.402"/></svg>`
const ICON_PIP_ENTER = `<svg class="media-icon media-icon--pip-enter" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M13 2a4 4 0 0 1 4 4v2.035A3.5 3.5 0 0 0 16.5 8H15V6.273C15 5.018 13.96 4 12.679 4H4.32C3.04 4 2 5.018 2 6.273v5.454C2 12.982 3.04 14 4.321 14H6v1.5q0 .255.035.5H4a4 4 0 0 1-4-4V6a4 4 0 0 1 4-4z"/><rect width="10" height="7" x="8" y="10" fill="currentColor" rx="2"/><path fill="currentColor" d="M7.129 5.547a.6.6 0 0 0-.656.13L3.677 8.473A.6.6 0 0 0 4.102 9.5h2.796c.332 0 .602-.27.602-.602V6.103a.6.6 0 0 0-.371-.556"/></svg>`
const ICON_PIP_EXIT = `<svg class="media-icon media-icon--pip-exit" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M13 2a4 4 0 0 1 4 4v2.036A3.5 3.5 0 0 0 16.5 8H15V6.273C15 5.018 13.96 4 12.679 4H4.32C3.04 4 2 5.018 2 6.273v5.454C2 12.982 3.04 14 4.321 14H6v1.5q0 .255.036.5H4a4 4 0 0 1-4-4V6a4 4 0 0 1 4-4z"/><rect width="10" height="7" x="8" y="10" fill="currentColor" rx="2"/><path fill="currentColor" d="M4.871 10.454a.6.6 0 0 0 .656-.131l2.796-2.796A.6.6 0 0 0 7.898 6.5H5.102a.603.603 0 0 0-.602.602v2.795a.6.6 0 0 0 .371.556"/></svg>`
const ICON_FS_ENTER = `<svg class="media-icon media-icon--fullscreen-enter" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M9.57 3.617A1 1 0 0 0 8.646 3H4c-.552 0-1 .449-1 1v4.646a.996.996 0 0 0 1.001 1 1 1 0 0 0 .706-.293l4.647-4.647a1 1 0 0 0 .216-1.089m4.812 4.812a1 1 0 0 0-1.089.217l-4.647 4.647a.998.998 0 0 0 .708 1.706H14c.552 0 1-.449 1-1V9.353a1 1 0 0 0-.618-.924"/></svg>`
const ICON_FS_EXIT = `<svg class="media-icon media-icon--fullscreen-exit" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M7.883 1.93a.99.99 0 0 0-1.09.217L2.146 6.793A.998.998 0 0 0 2.853 8.5H7.5c.551 0 1-.449 1-1V2.854a1 1 0 0 0-.617-.924m7.263 7.57H10.5c-.551 0-1 .449-1 1v4.646a.996.996 0 0 0 1.001 1.001 1 1 0 0 0 .706-.293l4.646-4.646a.998.998 0 0 0-.707-1.707z"/></svg>`
const ICON_CAST_ENTER = `<svg class="media-icon media-icon--cast-enter" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M.75 13.25c1.38 0 2.5 1.085 2.5 2.5V16H.5v-2.75z"/><path fill="currentColor" d="M.75 10.25c3.04 0 5.5 2.46 5.5 5.5V16h-2v-.25c0-1.96-1.567-3.5-3.5-3.5H.5v-2z"/><path fill="currentColor" d="M.75 7.25a8.5 8.5 0 0 1 8.5 8.5V16h-2v-.25c0-3.611-2.91-6.5-6.5-6.5H.5v-2z"/><path fill="currentColor" d="M17.5 14.25c0 .963-.787 1.75-1.75 1.75h-5.5v-2h5.25V4h-13v2.25h-2v-2.5C.5 2.787 1.287 2 2.25 2h13.5c.963 0 1.75.787 1.75 1.75z"/></svg>`
const ICON_CAST_EXIT = `<svg class="media-icon media-icon--cast-exit" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M.75 13.25c1.38 0 2.5 1.085 2.5 2.5V16H.5v-2.75z"/><path fill="currentColor" d="M.75 10.25c3.04 0 5.5 2.46 5.5 5.5V16h-2v-.25c0-1.96-1.567-3.5-3.5-3.5H.5v-2z"/><path fill="currentColor" d="M.75 7.25a8.5 8.5 0 0 1 8.5 8.5V16h-2v-.25c0-3.611-2.91-6.5-6.5-6.5H.5v-2z"/><path fill="currentColor" d="M17.5 14.25c0 .963-.787 1.75-1.75 1.75h-5.5v-2h5.25V4h-13v2.25h-2v-2.5C.5 2.787 1.287 2 2.25 2h13.5c.963 0 1.75.787 1.75 1.75z"/><path fill="currentColor" d="M4 5.5v1.164c2.143-.021 5.979 3.836 5.979 5.979H14V5.5z"/></svg>`
const ICON_SPINNER = `<svg class="media-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" aria-hidden="true" viewBox="0 0 18 18"><rect width="2" height="5" x="8" y=".5" opacity=".5" rx="1"><animate attributeName="opacity" begin="0s" calcMode="linear" dur="1s" repeatCount="indefinite" values="1;0"/></rect><rect width="2" height="5" x="12.243" y="2.257" opacity=".45" rx="1" transform="rotate(45 13.243 4.757)"><animate attributeName="opacity" begin="0.125s" calcMode="linear" dur="1s" repeatCount="indefinite" values="1;0"/></rect><rect width="5" height="2" x="12.5" y="8" opacity=".4" rx="1"><animate attributeName="opacity" begin="0.25s" calcMode="linear" dur="1s" repeatCount="indefinite" values="1;0"/></rect><rect width="5" height="2" x="10.743" y="12.243" opacity=".35" rx="1" transform="rotate(45 13.243 13.243)"><animate attributeName="opacity" begin="0.375s" calcMode="linear" dur="1s" repeatCount="indefinite" values="1;0"/></rect><rect width="2" height="5" x="8" y="12.5" opacity=".3" rx="1"><animate attributeName="opacity" begin="0.5s" calcMode="linear" dur="1s" repeatCount="indefinite" values="1;0"/></rect><rect width="2" height="5" x="3.757" y="10.743" opacity=".25" rx="1" transform="rotate(45 4.757 13.243)"><animate attributeName="opacity" begin="0.625s" calcMode="linear" dur="1s" repeatCount="indefinite" values="1;0"/></rect><rect width="5" height="2" x=".5" y="8" opacity=".15" rx="1"><animate attributeName="opacity" begin="0.75s" calcMode="linear" dur="1s" repeatCount="indefinite" values="1;0"/></rect><rect width="5" height="2" x="2.257" y="3.757" opacity=".1" rx="1" transform="rotate(45 4.757 4.757)"><animate attributeName="opacity" begin="0.875s" calcMode="linear" dur="1s" repeatCount="indefinite" values="1;0"/></rect></svg>`
const ICON_SPINNER_PREVIEW = ICON_SPINNER.replace(
    'class="media-icon"',
    'class="media-preview__spinner media-icon"'
)
const ICON_SPINNER_BUFFER = ICON_SPINNER

export interface SkinOptions {
    poster?: string
    live?: boolean
}

export function buildSkin(
    media: HTMLElement,
    options: SkinOptions
): HTMLElement {
    const container = document.createElement("media-container")
    container.className = "media-default-skin media-default-skin--video"

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

    // Live skin: drop seek buttons, current/duration time displays, and the
    // thumbnail preview (no thumbs available for live). Show a LIVE badge in
    // the time-controls area instead of the time displays.
    const leftButtons = live
        ? `<media-play-button commandfor="${ID_PLAY}" class="media-button media-button--subtle media-button--icon media-button--play">
              ${ICON_RESTART}${ICON_PLAY}${ICON_PAUSE}
            </media-play-button>
            <media-tooltip id="${ID_PLAY}" side="top" class="media-surface media-tooltip"></media-tooltip>`
        : `<media-play-button commandfor="${ID_PLAY}" class="media-button media-button--subtle media-button--icon media-button--play">
              ${ICON_RESTART}${ICON_PLAY}${ICON_PAUSE}
            </media-play-button>
            <media-tooltip id="${ID_PLAY}" side="top" class="media-surface media-tooltip"></media-tooltip>

            <media-seek-button commandfor="${ID_SEEK_BACK}" seconds="${-SEEK_TIME}" class="media-button media-button--subtle media-button--icon media-button--seek">
              <span class="media-icon__container">
                ${ICON_SEEK_FLIPPED}<span class="media-icon__label">${SEEK_TIME}</span>
              </span>
            </media-seek-button>
            <media-tooltip id="${ID_SEEK_BACK}" side="top" class="media-surface media-tooltip">Seek backward ${SEEK_TIME} seconds</media-tooltip>

            <media-seek-button commandfor="${ID_SEEK_FWD}" seconds="${SEEK_TIME}" class="media-button media-button--subtle media-button--icon media-button--seek">
              <span class="media-icon__container">
                ${ICON_SEEK}<span class="media-icon__label">${SEEK_TIME}</span>
              </span>
            </media-seek-button>
            <media-tooltip id="${ID_SEEK_FWD}" side="top" class="media-surface media-tooltip">Seek forward ${SEEK_TIME} seconds</media-tooltip>`

    const timeControls = live
        ? `<bccm-live-button></bccm-live-button>`
        : `<media-time type="current" class="media-time"></media-time>
            <media-time-slider class="media-slider">
              <media-slider-track class="media-slider__track">
                <media-slider-fill class="media-slider__fill"></media-slider-fill>
                <media-slider-buffer class="media-slider__buffer"></media-slider-buffer>
              </media-slider-track>
              <media-slider-thumb class="media-slider__thumb"></media-slider-thumb>
              <div class="media-surface media-preview media-slider__preview">
                <media-slider-thumbnail class="media-preview__thumbnail"></media-slider-thumbnail>
                <media-slider-value type="pointer" class="media-time media-preview__time"></media-slider-value>
                ${ICON_SPINNER_PREVIEW}
              </div>
            </media-time-slider>
            <media-time type="duration" class="media-time"></media-time>`

    container.innerHTML = `
      <media-poster></media-poster>

      <media-buffering-indicator class="media-buffering-indicator">
        <div class="media-surface">${ICON_SPINNER_BUFFER}</div>
      </media-buffering-indicator>

      <media-error-dialog class="media-error">
        <div class="media-error__dialog media-surface">
          <div class="media-error__content">
            <media-alert-dialog-title class="media-error__title">Something went wrong.</media-alert-dialog-title>
            <media-alert-dialog-description class="media-error__description"></media-alert-dialog-description>
          </div>
          <div class="media-error__actions">
            <media-alert-dialog-close class="media-button media-button--primary">OK</media-alert-dialog-close>
          </div>
        </div>
      </media-error-dialog>

      <media-controls class="media-surface media-controls">
        <media-tooltip-group>
          <div class="media-button-group">
            ${leftButtons}
          </div>

          <div class="media-time-controls">
            ${timeControls}
          </div>

          <div class="media-button-group" data-bccm-right-group>
            ${live ? "" : `<bccm-playback-rate-picker></bccm-playback-rate-picker>`}

            <media-mute-button commandfor="${ID_VOLUME}" class="media-button media-button--subtle media-button--icon media-button--mute">
              ${ICON_VOLUME_OFF}${ICON_VOLUME_LOW}${ICON_VOLUME_HIGH}
            </media-mute-button>

            <media-popover id="${ID_VOLUME}" open-on-hover delay="200" close-delay="100" side="top" class="media-surface media-popover media-popover--volume">
              <media-volume-slider class="media-slider" orientation="vertical" thumb-alignment="edge">
                <media-slider-track class="media-slider__track">
                  <media-slider-fill class="media-slider__fill"></media-slider-fill>
                </media-slider-track>
                <media-slider-thumb class="media-slider__thumb media-slider__thumb--persistent"></media-slider-thumb>
              </media-volume-slider>
            </media-popover>

            <bccm-audio-picker></bccm-audio-picker>
            <bccm-subtitle-picker></bccm-subtitle-picker>
            <bccm-quality-picker></bccm-quality-picker>

            <media-cast-button commandfor="${ID_CAST}" class="media-button media-button--subtle media-button--icon media-button--cast">
              ${ICON_CAST_ENTER}${ICON_CAST_EXIT}
            </media-cast-button>
            <media-tooltip id="${ID_CAST}" side="top" class="media-surface media-tooltip"></media-tooltip>

            <media-pip-button commandfor="${ID_PIP}" class="media-button media-button--subtle media-button--icon media-button--pip">
              ${ICON_PIP_ENTER}${ICON_PIP_EXIT}
            </media-pip-button>
            <media-tooltip id="${ID_PIP}" side="top" class="media-surface media-tooltip"></media-tooltip>

            <media-fullscreen-button commandfor="${ID_FS}" class="media-button media-button--subtle media-button--icon media-button--fullscreen">
              ${ICON_FS_ENTER}${ICON_FS_EXIT}
            </media-fullscreen-button>
            <media-tooltip id="${ID_FS}" side="top" class="media-surface media-tooltip"></media-tooltip>

            ${isSmartTV() ? `<bccm-dismiss-controls-button></bccm-dismiss-controls-button>` : ""}
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
      ${
          live
              ? ""
              : `<media-hotkey keys="ArrowRight" action="seekStep" value="5"></media-hotkey>
      <media-hotkey keys="ArrowLeft" action="seekStep" value="-5"></media-hotkey>
      <media-hotkey keys="l" action="seekStep" value="10"></media-hotkey>
      <media-hotkey keys="j" action="seekStep" value="-10"></media-hotkey>
      <media-hotkey keys="0-9" action="seekToPercent"></media-hotkey>
      <media-hotkey keys="Home" action="seekToPercent" value="0"></media-hotkey>
      <media-hotkey keys="End" action="seekToPercent" value="100"></media-hotkey>`
      }

      <media-gesture type="tap" action="togglePaused" pointer="mouse" region="center"></media-gesture>
      <media-gesture type="tap" action="toggleControls" pointer="touch"></media-gesture>
      <media-gesture type="doubletap" action="toggleFullscreen" region="center"></media-gesture>
      ${
          live
              ? ""
              : `<media-gesture type="doubletap" action="seekStep" value="-10" region="left"></media-gesture>
      <media-gesture type="doubletap" action="seekStep" value="10" region="right"></media-gesture>`
      }
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

    return container
}
