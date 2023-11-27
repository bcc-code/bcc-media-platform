import { currentWebView } from "@/utils/webview"
import { WebView } from "@/webview"

class WebViewStudyHandler {
    handlerName: string
    webView: WebView
    constructor(webView: WebView) {
        this.webView = webView
        this.handlerName = webView.type == "flutter" ? "flutter_study" : "study"
    }

    tasksCompleted() {
        this.webView.communication.callHandler(
            this.handlerName,
            "tasks_completed"
        )
    }
}

export const webViewStudy = currentWebView
    ? new WebViewStudyHandler(currentWebView)
    : null
