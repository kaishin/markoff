import Cocoa
import WebKit

class RenderViewController: NSViewController {
  var webView: WKWebView!
  let parser = MarkdownParser()
  var viewModel: RenderViewModel? {
    didSet {
      let prelude = "<body style='font-family:\"Helvetica\"'>"
      let html = prelude + viewModel!.HTMLString + "</body>"
      webView.loadHTMLString(html, baseURL: nil)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
  }

  override func viewDidAppear() {
    super.viewDidAppear()
    listenToDocumentChangeSignal()

    guard let document = view.window?.windowController?.document as? MarkdownDocument else { return }
    self.viewModel = RenderViewModel(HTMLString: document.HTML.value)
  }

  private func listenToDocumentChangeSignal() {
    guard let windowController = view.window?.windowController as? WindowController else { return }

    windowController.documentChangeSignal.observe(next: { output in
      self.viewModel = RenderViewModel(HTMLString: output)
    })
  }

  private func setupWebView() {
    webView = WKWebView(frame: view.bounds, configuration: WKWebViewConfiguration())
    view.addSubview(webView)
    webView.translatesAutoresizingMaskIntoConstraints = false

    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|",
      options: NSLayoutFormatOptions(),
      metrics: nil,
      views: ["webView": webView]))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|",
      options: NSLayoutFormatOptions(),
      metrics: nil,
      views: ["webView": webView]))
  }
}

