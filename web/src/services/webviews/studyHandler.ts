import { currentWebView } from '@/utils/webview'
import { WebView } from '@/webview'

export type WebViewStudyHandlerCompletedTask = {
    questionId: string
    answerId: string
    answeredCorrectly: boolean
}

class WebViewStudyHandler {
    handlerName: string
    webView: WebView
    constructor(webView: WebView) {
        this.webView = webView
        this.handlerName = webView.type == 'flutter' ? 'flutter_study' : 'study'
    }

    tasksCompleted(answers?: WebViewStudyHandlerCompletedTask[]) {
        this.webView.communication.callHandler(
            this.handlerName,
            'tasks_completed',
            answers
        )
    }
}

export const webViewStudy = currentWebView
    ? new WebViewStudyHandler(currentWebView)
    : null
