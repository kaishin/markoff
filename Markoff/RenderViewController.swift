import Cocoa
import WebKit

class RenderViewController: NSViewController {
  let parser = MarkdownParser()
  lazy var webView: WebView = {
    return WebView(frame: self.view.bounds)
  }()

  var viewModel: RenderViewModel? {
    didSet {
      webView.loadHTMLString(viewModel!.fullPageString, baseURL: viewModel!.baseURL)
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

    windowController.documentChangeSignal.observeNext { output in
      self.viewModel = RenderViewModel(HTMLString: output)
    }
  }

  private func setupWebView() {
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

