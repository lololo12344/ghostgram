import Foundation
import UIKit
import Display
import AsyncDisplayKit
@preconcurrency import WebKit
import TelegramPresentationData
import AccountContext

private final class GGPluginWeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private let handler: (WKScriptMessage) -> Void

    init(handler: @escaping (WKScriptMessage) -> Void) {
        self.handler = handler
        super.init()
    }

    func userContentController(_ controller: WKUserContentController, didReceive scriptMessage: WKScriptMessage) {
        self.handler(scriptMessage)
    }
}

public final class GGPluginEditorController: ViewController {
    private let context: AccountContext
    private var webView: WKWebView?

    public init(context: AccountContext) {
        self.context = context
        super.init(navigationBarPresentationData: NavigationBarPresentationData(presentationData: context.sharedContext.currentPresentationData.with { $0 }))
        self.title = "GGPlugin IDE"
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadDisplayNode() {
        self.displayNode = ASDisplayNode()
        self.displayNode.backgroundColor = .black

        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        let weakHandler = GGPluginWeakScriptMessageHandler { [weak self] message in
            self?.handlePluginMessage(message)
        }
        contentController.add(weakHandler, name: "GGPlugin")
        configuration.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.bounces = false
        self.webView = webView
        self.displayNode.view.addSubview(webView)

        loadIdeHtml()
    }

    private func loadIdeHtml() {
        guard let webView = self.webView else { return }

        var bundlePath: String?
        if let path = Bundle.main.path(forResource: "SettingsUIBundle", ofType: "bundle") {
            bundlePath = path
        } else if let resourcePath = Bundle.main.resourcePath {
            let direct = (resourcePath as NSString).appendingPathComponent("SettingsUIBundle.bundle")
            if FileManager.default.fileExists(atPath: direct) {
                bundlePath = direct
            }
        }

        if let bundlePath = bundlePath,
           let bundle = Bundle(path: bundlePath),
           let htmlPath = bundle.path(forResource: "ide", ofType: "html") {
            let htmlUrl = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(htmlUrl, allowingReadAccessTo: bundle.bundleURL)
        } else {
            let fallbackHtml = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>GGPlugin IDE</title>
            <style>
            body { background: #121212; color: #fff; font-family: -apple-system, sans-serif; padding: 20px; }
            h1 { color: #8A2BE2; }
            p { color: #aaa; line-height: 1.5; }
            .btn { background: #8A2BE2; color: #fff; border: none; padding: 10px 20px; border-radius: 8px; font-weight: bold; }
            </style>
            </head>
            <body>
            <h1>GGPlugin Engine 13.0</h1>
            <p>Встроенная среда разработки пользовательских расширений и скриптов Ghostgram.</p>
            <p>Все плагины и скрипты выполняются локально с полным доступом к GGAPI.</p>
            <button class="btn" onclick="alert('GGPlugin активен и готов к работе!')">Проверить статус</button>
            </body>
            </html>
            """
            webView.loadHTMLString(fallbackHtml, baseURL: nil)
        }
    }

    private func handlePluginMessage(_ message: WKScriptMessage) {
        if let body = message.body as? [String: Any], let action = body["action"] as? String {
            switch action {
            case "alert":
                if let text = body["text"] as? String {
                    let alert = textAlertController(context: self.context, title: "GGPlugin", text: text, actions: [TextAlertAction(type: .defaultAction, title: "OK", action: {})])
                    self.present(alert, in: .window(.root))
                }
            default:
                break
            }
        }
    }

    override public func containerLayoutUpdated(_ layout: ContainerViewLayout, transition: ContainedViewLayoutTransition) {
        super.containerLayoutUpdated(layout, transition: transition)
        let navigationHeight = self.navigationLayout(layout: layout).navigationFrame.maxY
        let bounds = CGRect(x: 0, y: navigationHeight, width: layout.size.width, height: max(0, layout.size.height - navigationHeight))
        transition.updateFrame(view: self.webView ?? UIView(), frame: bounds)
    }
}
