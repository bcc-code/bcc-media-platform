import { FlutterWebView } from "@/flutter"

class FlutterMain {
    handlerName = "flutter_main"
    webView: FlutterWebView
    constructor(webView: FlutterWebView) {
        this.webView = webView
    }

    navigate(path: String) {
        this.webView.callHandler(this.handlerName, "navigate", path)
    }

    getAccessToken(): Promise<String | null> {
        return this.webView.callHandler(this.handlerName, "get_access_token")
    }

    getLocale(): Promise<String | null> {
        return this.webView.callHandler(this.handlerName, "get_locale")
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
}

export const flutterStudy =
    window.flutter_inappwebview != null
        ? new FlutterStudy(window.flutter_inappwebview)
        : null