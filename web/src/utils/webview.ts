import { analytics } from '@/services/analytics'
import { WebView, WebViewCommunication, WebViewType } from '@/webview'

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
            type: 'flutter',
            communication: window.flutter_inappwebview,
        }
    } else if (window.xamarin_webview) {
        return {
            type: 'xamarin',
            communication: window.xamarin_webview,
        }
    } else if (window.flutter_webview_manager) {
        return {
            type: 'flutter_webview_manager',
            communication: window.flutter_webview_manager,
        }
    }
    return undefined
}

function waitForWebview(): Promise<WebView> {
    return new Promise((resolve, reject) => {
        window.addEventListener('app_webview_ready', () => {
            // Override webview communication to log errors
            window.flutter_webview_manager = {
                // @ts-expect-error ignore
                // eslint-disable-next-line no-shadow-restricted-names
                callHandler: async (name, ...arguments) => {
                    const requestId = Math.random().toString(36).substring(7);
                    // @ts-expect-error ignore
                    window.flutter_channel.postMessage(JSON.stringify({
                        requestId,
                        name,
                        arguments,
                    }));

                    // @ts-expect-error ignore
                    while (!(requestId in window.flutterResponses)) {
                        await new Promise(resolve => setTimeout(resolve, 100));
                    }
                    // @ts-expect-error ignore
                    const data = window.flutterResponses[requestId];
                    // @ts-expect-error ignore
                    delete window.flutterResponses[requestId];
                    if (data instanceof Error) {
                        throw data;
                    }
                    return data;
                },
                // @ts-expect-error ignore
                respond: (id, result) => {
                    // @ts-expect-error ignore
                    window.flutterResponses[id] = result;
                },
                // @ts-expect-error ignore
                respondError: (id, error) => {
                    // @ts-expect-error ignore
                    window.flutterResponses[id] = new Error(error);
                    analytics.track('error', { message: 'Error calling study handler', data: { id, error } })
                }
            };
            // Override webview communication to log errors end

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
        .get('webview_delayed_type')
        ?.toLowerCase() as WebViewType | null
    if (typeQueryParam) {
        sessionStorage.setItem('webview_delayed_type', typeQueryParam)
        return typeQueryParam
    }
    const storedType = sessionStorage.getItem(
        'webview_delayed_type'
    ) as WebViewType | null
    return storedType ? storedType : undefined
}

function clearWebViewDataIfRequested() {
    const urlParams = new URLSearchParams(window.location.search)
    const clearQueryParam = urlParams.get('webview_clear')?.toLowerCase() as
        | any
        | null
    if (clearQueryParam == 'true') {
        sessionStorage.removeItem('webview_delayed_type')
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
const delayedWebViewType = inIframe() ? null : getDelayedWebViewType()
if (currentWebView == null && delayedWebViewType) {
    currentWebView = {
        type: delayedWebViewType,
        communication: new DelayedWebViewCommunication(
            waitForWebview().then((webview) => webview.communication)
        ),
    }
}

export { currentWebView }
