declare global {
    interface Window {
        flutter_inappwebview: WebViewCommunication | undefined
        xamarin_webview: WebViewCommunication | undefined
    }
}

export declare type WebViewType = "flutter" | "xamarin"
export declare type WebViewCommunication = {
    callHandler(...args)
}
export declare type WebView = {
    type: WebViewType
    communication: WebViewCommunication
}

export {}
