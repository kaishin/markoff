// Based on https://github.com/kylehickinson/SwiftUI-WebView

import SwiftUI
import Combine
import WebKit

class WebViewStore: ObservableObject {
  private var observers = Set<NSKeyValueObservation>()

  @Published  var webView: WKWebView {
    didSet {
      setupObservers()
    }
  }

  init(webView: WKWebView = .init()) {
    self.webView = webView

    #if DEBUG
    self.webView
      .configuration
      .preferences
      .setValue(true, forKey: "developerExtrasEnabled")
    #endif

    setupObservers()
  }

  private func setupObservers() {
    func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
      webView.observe(keyPath, options: [.prior]) { _, change in
        if change.isPrior {
          self.objectWillChange.send()
        }
      }
    }

    observers = [
      subscriber(for: \.title),
      subscriber(for: \.url),
      subscriber(for: \.isLoading),
      subscriber(for: \.estimatedProgress),
      subscriber(for: \.hasOnlySecureContent),
      subscriber(for: \.serverTrust),
      subscriber(for: \.canGoBack),
      subscriber(for: \.canGoForward)
    ]
  }
}

extension WebViewStore {
  func update(_ HTML: String, baseURL: URL? = nil) {
    webView.evaluateJavaScript("window.pageYOffset") { [weak self] object, error in
      self?.webView.loadHTMLString(HTML, baseURL: baseURL)

      if let offset = object as? Int {
        self?.scrollTo(offset)
      }
    }
  }

  private func scrollTo(_ YOffset: Int) {
    let script = "window.scrollTo(0, \(YOffset));"
    let scrollScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    self.webView.configuration.userContentController.addUserScript(scrollScript)
  }
}

struct WebView: View, NSViewRepresentable {
  let webView: WKWebView

  init(webView: WKWebView) {
    self.webView = webView
  }

  func makeNSView(context: Context) -> WKWebView {
    return webView
  }

  func updateNSView(_ view: WKWebView, context: Context) {}
}

