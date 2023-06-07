declare global {
    interface Window {
        flutter_inappwebview: WebViewCommunication | undefined,
        xamarin_webview: WebViewCommunication | undefined,
    }
}

export declare type WebViewCommunication = {
    callHandler(...args)
}

export { }
