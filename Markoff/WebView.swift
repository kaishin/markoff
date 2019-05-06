import WebKit

class WebView: WKWebView {
  var lastOffset = 0

  init(frame: CGRect) {
    let config = WKWebViewConfiguration()

    #if DEBUG
    config.preferences.setValue(true, forKey: "developerExtrasEnabled")
    #endif

    super.init(frame: frame, configuration: config)
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func update(_ HTML: String, baseURL: URL) {
    evaluateJavaScript("window.pageYOffset") { object, error in
      self.loadHTMLString(HTML, baseURL: baseURL)

      if let offset = object as? Int {
        self.scrollTo(offset)
      }
    }
  }

  private func scrollTo(_ YOffset: Int) {
    let script = "window.scrollTo(0, \(YOffset));"
    let scrollScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    configuration.userContentController.addUserScript(scrollScript)
  }
}
