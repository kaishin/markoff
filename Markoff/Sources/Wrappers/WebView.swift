
import SwiftUI
import WebKit

let scrollPositionUpdated = "scrollPositionUpdated"

struct WebView: NSViewRepresentable {
  var html: String
  var baseURL: URL?
  @Binding var scrollPosition: Float

  init(html: String, scrollPosition: Binding<Float>) {
    self.html = html
    self._scrollPosition = scrollPosition
  }

  func makeNSView(context: Context) -> WKWebView {
    let config = WKWebViewConfiguration()
    let contentController = WKUserContentController()

    contentController.addUserScript(
      .init(
        source: scrollPositionJavaScript(),
        injectionTime: .atDocumentEnd,
        forMainFrameOnly: true
      )
    )

    contentController.add(context.coordinator, name: scrollPositionUpdated)
    config.userContentController = contentController

    #if DEBUG
    config
      .preferences
      .setValue(true, forKey: "developerExtrasEnabled")
    #endif
    
    let webView = WKWebView(frame: .zero, configuration: config)
    webView.navigationDelegate = context.coordinator

    return webView
  }

  func updateNSView(_ view: WKWebView, context: Context) {
    view.loadHTMLString(html, baseURL: baseURL)
    view.scrollTo(scrollPosition)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(scrollPosition: $scrollPosition)
  }
}

extension WebView {
  class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    @Binding var scrollPosition: Float

    init(scrollPosition: Binding<Float>) {
      self._scrollPosition = scrollPosition
    }

    func userContentController(
      _ userContentController: WKUserContentController,
      didReceive message: WKScriptMessage
    ) {
      guard message.name == scrollPositionUpdated else { return }
      scrollPosition = message.body as? Float ?? 0
    }

    func webView(
      _: WKWebView,
      decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
      switch navigationAction.navigationType {
      case .linkActivated:
        guard let url = navigationAction.request.url else { return }

        let urlStringWithoutFragment = url.absoluteString.replacingOccurrences(
          of: "#" + (url.fragment ?? ""),
          with: ""
        )

        // TODO: Improve detection of local URLs
        if !urlStringWithoutFragment.contains("http") {
          decisionHandler(.allow)
        } else {
          decisionHandler(.cancel)
          NSWorkspace.shared.open(url)
        }
        
      default:
        decisionHandler(.allow)
      }
    }
  }
}

extension WKWebView {
  func scrollTo(_ YOffset: Float) {
    evaluateJavaScript("window.scrollTo(0, \(YOffset));")
  }
}

func scrollPositionJavaScript() -> String {
  let url = Bundle.main.url(forResource: "scrollPosition", withExtension: "js")
  return try! String(contentsOf: url!)
}
