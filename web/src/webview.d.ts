declare global {
    interface Window {
        flutter_inappwebview: WebViewCommunication | undefined
        xamarin_webview: WebViewCommunication | undefined
        flutter_webview_manager: WebViewCommunication | undefined
    }
}

export declare type WebViewType = "flutter" | "xamarin" | "flutter_webview_manager"
export declare type WebViewCommunication = {
    callHandler(...args)
}
export declare type WebView = {
    type: WebViewType
    communication: WebViewCommunication
}

export { }
