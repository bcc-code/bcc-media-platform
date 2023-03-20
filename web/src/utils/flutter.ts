import { FlutterWebView } from "@/flutter"

type HapticFeedbackType =
    | "lightImpact"
    | "mediumImpact"
    | "vibrate"
    | "selectionClick"
    | "heavyImpact"

class FlutterMain {
    handlerName = "flutter_main"
    webView: FlutterWebView
    constructor(webView: FlutterWebView) {
        this.webView = webView
    }

    navigate(path: String): Promise<any> | null {
        var promise = this.webView.callHandler(
            this.handlerName,
            "navigate",
            path
        )
        return !promise?.then ? null : promise
    }

    push(path: String): Promise<any> {
        var promise = this.webView.callHandler(this.handlerName, "push", path)
        return !promise?.then ? null : promise
    }

    getAccessToken(): Promise<string | null> {
        return this.webView.callHandler(this.handlerName, "get_access_token")
    }

    getLocale(): Promise<string | null> {
        return this.webView.callHandler(this.handlerName, "get_locale")
    }

    shareImage(url: string): Promise<boolean | null> {
        return this.webView.callHandler(this.handlerName, "share_image", url)
    }

    hapticFeedback(
        hapticFeedbackType: HapticFeedbackType
    ): Promise<boolean | null> {
        return this.webView.callHandler(
            this.handlerName,
            "haptic_feedback",
            hapticFeedbackType
        )
    }
}

export const flutter =
    window.flutter_inappwebview != null
        ? new FlutterMain(window.flutter_inappwebview)
        : null

class FlutterStudy {
    handlerName = "flutter_study"
    webView: FlutterWebView
    constructor(webView: FlutterWebView) {
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
    const newUrl = addQueryParameter(url, "launch_url", "true")
    window.location.assign(newUrl)
}