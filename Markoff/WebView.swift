import WebKit

class WebView: WKWebView {
  let contentOffset = 0.0

  init(frame: CGRect) {
    let config = WKWebViewConfiguration()
    config.userContentController = WKUserContentController()
    let autoScrollCode = "window.scrollTo(0,document.body.scrollHeight);"
    let autoScrollScript = WKUserScript(source: autoScrollCode, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
    config.userContentController.addUserScript(autoScrollScript)

    #if DEBUG
      config.preferences.setValue(true, forKey: "developerExtrasEnabled")
    #endif

    super.init(frame: frame, configuration: config)
  }
}
