import { WebView, WebViewCommunication, WebViewType } from "@/webview"

class DelayedWebViewCommunication implements WebViewCommunication {
    webviewPromise: Promise<WebViewCommunication>
    constructor(webviewPromise: Promise<WebViewCommunication>) {
        this.webviewPromise = webviewPromise
    }

    async callHandler(handlerName: string, ...args: any[]) {
        const webview = await this.webviewPromise
        return webview.callHandler(handlerName, ...args)
    }
}

function getWebView(): WebView | undefined {
    if (window.flutter_inappwebview) {
        return {
            type: "flutter",
            communication: window.flutter_inappwebview,
        }
    } else if (window.xamarin_webview) {
        return {
            type: "xamarin",
            communication: window.xamarin_webview,
        }
    }
    return undefined
}

function waitForWebview(): Promise<WebView> {
    return new Promise((resolve, reject) => {
        window.addEventListener("app_webview_ready", () => {
            const webViewCommunication = getWebView()
            if (webViewCommunication) {
                resolve(webViewCommunication)
            } else {
                reject()
            }
        })
    })
}

function getDelayedWebViewType(): WebViewType | undefined {
    const urlParams = new URLSearchParams(window.location.search)
    const typeQueryParam = urlParams
        .get("webview_delayed_type")
        ?.toLowerCase() as WebViewType | null
    if (typeQueryParam) {
        sessionStorage.setItem("webview_delayed_type", typeQueryParam)
        return typeQueryParam
    }
    const storedType = sessionStorage.getItem(
        "webview_delayed_type"
    ) as WebViewType | null
    return storedType ? storedType : undefined
}

function clearWebViewDataIfRequested() {
    const urlParams = new URLSearchParams(window.location.search)
    const clearQueryParam = urlParams.get("webview_clear")?.toLowerCase() as
        | any
        | null
    if (clearQueryParam == "true") {
        sessionStorage.removeItem("webview_delayed_type")
    }
}

function inIframe() {
    try {
        return window.self !== window.top
    } catch (e) {
        return true
    }
}

clearWebViewDataIfRequested()
let currentWebView = getWebView()
const delayedWebViewType = !inIframe() ? getDelayedWebViewType() : false
if (currentWebView == null && delayedWebViewType) {
    currentWebView = {
        type: delayedWebViewType,
        communication: new DelayedWebViewCommunication(
            waitForWebview().then((webview) => webview.communication)
        ),
    }
}

export { currentWebView }
