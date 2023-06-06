import { WebViewCommunication } from "@/flutter"
import settings from "@/services/settings"

type HapticFeedbackType =
    | "lightImpact"
    | "mediumImpact"
    | "vibrate"
    | "selectionClick"
    | "heavyImpact"

class AppWebView {
    handlerName = "flutter_main"
    webview: WebViewCommunication
    constructor(handlerName: string, webView: WebViewCommunication) {
        this.webview = webView
        this.handlerName = handlerName
    }

    navigate(path: string): Promise<any> | null {
        var promise = this.webview.callHandler(
            this.handlerName,
            "navigate",
            path
        )
        return !promise?.then ? null : promise
    }

    push(path: string): Promise<any> {
        var promise = this.webview.callHandler(this.handlerName, "push", path)
        return !promise?.then ? null : promise
    }

    getAccessToken(): Promise<string | null> {
        return this.webview.callHandler(this.handlerName, "get_access_token")
    }

    getLocale(): Promise<string | null> {
        return this.webview.callHandler(this.handlerName, "get_locale")
    }

    shareImage(url: string): Promise<boolean | null> {
        return this.webview.callHandler(this.handlerName, "share_image", url)
    }

    hapticFeedback(
        hapticFeedbackType: HapticFeedbackType
    ): Promise<boolean | null> {
        return this.webview.callHandler(
            this.handlerName,
            "haptic_feedback",
            hapticFeedbackType
        )
    }
}

export const appWebView =
    window.flutter_inappwebview != null
        ? new AppWebView('flutter_main', window.flutter_inappwebview)
        : window.xamarin_webview != null
            ? new AppWebView('main', window.xamarin_webview)
            : null


class FlutterStudy {
    handlerName = "flutter_study"
    webView: WebViewCommunication
    constructor(webView: WebViewCommunication) {
        this.webView = webView
    }

    tasksCompleted() {
        this.webView.callHandler(this.handlerName, "tasks_completed")
    }
    /* 
        pushThenTasksCompleted(path: String) {
            this.webView.callHandler(this.handlerName, "tasks_completed")
        } */
}

export const flutterStudy =
    window.flutter_inappwebview != null
        ? new FlutterStudy(window.flutter_inappwebview)
        : null

function addQueryParameter(
    url: string,
    name: string,
    value: string | number | boolean
) {
    const separator = url.indexOf("?") === -1 ? "?" : "&"
    return `${url}${separator}${name}=${encodeURIComponent(value)}`
}

export const openInBrowser = (url: string) => {
    let newUrl = addQueryParameter(url, "launch_url", "true")
    newUrl = addQueryParameter(newUrl, "locale", settings.locale)
    window.location.assign(newUrl)
}
