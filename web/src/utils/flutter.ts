import { FlutterWebView } from "@/flutter";

class FlutterRouter {
    handlerName = 'flutter_router_channel';
    webView: FlutterWebView;
    constructor(webView: FlutterWebView) {
        this.webView = webView;
    }

    navigate(path: String) {
        this.webView.callHandler(this.handlerName, 'navigate', path)
    }
}

export const flutterRouter = window.flutter_inappwebview != null ? new FlutterRouter(window.flutter_inappwebview) : null;

class FlutterStudy {
    static HandlerName = 'flutter_study_channel';
    handlerName = FlutterStudy.HandlerName;
    webView: FlutterWebView;
    constructor(webView: FlutterWebView) {
        this.webView = webView;
    }

    tasksCompleted() {
        this.webView.callHandler(this.handlerName, 'tasks_completed')
    }
}

export const flutterStudy = window.flutter_inappwebview != null ? new FlutterStudy(window.flutter_inappwebview) : null;
