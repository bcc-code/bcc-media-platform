import { currentWebView } from '@/utils/webview'
import type { WebView } from '@/webview'
import { analytics } from '../analytics'

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
        analytics.track('tasks_completed', { answers: answers })
        try {
            this.webView.communication.callHandler(
                this.handlerName,
                'tasks_completed',
                answers
            )
        } catch (err) {
            console.error(err)
            analytics.track('error', { message: 'Error calling study handler', data: { error: err } })
        }
    }
}

export const webViewStudy = currentWebView
    ? new WebViewStudyHandler(currentWebView)
    : null
