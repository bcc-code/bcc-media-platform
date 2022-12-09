import { FlutterWebView } from "@/flutter"

class FlutterRouter {
    handlerName = "flutter_router"
    webView: FlutterWebView
    constructor(webView: FlutterWebView) {
        this.webView = webView
    }

    navigate(path: String) {
        this.webView.callHandler(this.handlerName, "navigate", path)
    }
}

export const flutterRouter =
    window.flutter_inappwebview != null
        ? new FlutterRouter(window.flutter_inappwebview)
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

class FlutterAuth {
    handlerName = "flutter_auth"
    webView: FlutterWebView
    constructor(webView: FlutterWebView) {
        this.webView = webView
    }

    getAccessToken(): Promise<String | null> {
        return this.webView.callHandler(this.handlerName, "get_access_token")
    }
}

export const flutterAuth =
    window.flutter_inappwebview != null
        ? new FlutterAuth(window.flutter_inappwebview)
        : null
