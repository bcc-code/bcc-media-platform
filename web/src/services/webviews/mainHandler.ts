import { currentWebView } from "@/utils/webview"
import { WebView } from "@/webview"
import settings from "@/services/settings"

type HapticFeedbackType =
    | "lightImpact"
    | "mediumImpact"
    | "vibrate"
    | "selectionClick"
    | "heavyImpact"

class MainWebViewHandler {
    handlerName: string
    webView: WebView
    constructor(webView: WebView) {
        this.webView = webView
        this.handlerName = webView.type == "flutter" ? "flutter_main" : "main"
    }

    navigate(path: string): Promise<any> | null {
        var promise = this.webView.communication.callHandler(
            this.handlerName,
            "navigate",
            path
        )
        return !promise?.then ? null : promise
    }

    push(path: string): Promise<any> {
        var promise = this.webView.communication.callHandler(
            this.handlerName,
            "push",
            path
        )
        return !promise?.then ? null : promise
    }

    getAccessToken(): Promise<string | null> {
        return this.webView.communication.callHandler(
            this.handlerName,
            "get_access_token"
        )
    }

    getLocale(): Promise<string | null> {
        return this.webView.communication.callHandler(
            this.handlerName,
            "get_locale"
        )
    }

    shareImage(url: string): Promise<boolean | null> {
        return this.webView.communication.callHandler(
            this.handlerName,
            "share_image",
            url
        )
    }

    hapticFeedback(
        hapticFeedbackType: HapticFeedbackType
    ): Promise<boolean | null> {
        return this.webView.communication.callHandler(
            this.handlerName,
            "haptic_feedback",
            hapticFeedbackType
        )
    }
}

function addQueryParameter(
    url: string,
    name: string,
    value: string | number | boolean
): string {
    const separator = url.indexOf("?") === -1 ? "?" : "&"
    return `${url}${separator}${name}=${encodeURIComponent(value)}`
}

export const openInBrowser = (url: string) => {
    let newUrl = addQueryParameter(url, "launch_url", "true")
    newUrl = addQueryParameter(newUrl, "locale", settings.locale)
    window.location.assign(newUrl)
}

export const webViewMain = currentWebView
    ? new MainWebViewHandler(currentWebView)
    : null
