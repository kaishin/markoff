import Cocoa
import WebKit

class RenderViewController: NSViewController {
  @IBOutlet weak var openButton: NSButton!
  @IBOutlet weak var metadataLabel: NSTextField!

  let parser = MarkdownParser()
  lazy var webView: WebView = {
    return WebView(frame: self.view.bounds)
  }()

  var viewModel: RenderViewModel? {
    didSet {
      guard let HTML = viewModel?.fullPageString,
        let URL = viewModel?.baseURL
        else { return }
      onMain {
        self.webView.update(HTML, baseURL: URL)
        self.metadataLabel?.stringValue = self.viewModel!.metadata
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
    openButton.toolTip = "Open with \(PreferencesController().defaultEditor.name)"
  }

  override func viewDidAppear() {
    super.viewDidAppear()
    listenToDocumentChangeSignal()
    registerWindowName()

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
    view.addSubview(webView, positioned: .Below, relativeTo: view.subviews[0])
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.navigationDelegate = self

    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|",
      options: NSLayoutFormatOptions(),
      metrics: nil,
      views: ["webView": webView]))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|",
      options: NSLayoutFormatOptions(),
      metrics: nil,
      views: ["webView": webView]))
  }

  private func registerWindowName() {
    guard let window = view.window,
      let document = document
      else { return }
    window.setFrameAutosaveName(document.path)
  }

  private var document: MarkdownDocument? {
    guard let windowController = view.window?.windowController as? WindowController,
      let document = windowController.markdownDocument
      else { return nil }
    return document
  }
}

extension RenderViewController: WKNavigationDelegate {
  func webView(webView: WKWebView,
    decidePolicyForNavigationAction navigationAction: WKNavigationAction,
    decisionHandler: (WKNavigationActionPolicy) -> Void) {

    switch navigationAction.navigationType {
    case .LinkActivated:
      guard let url = navigationAction.request.URL else { return }
      let localPageURL = NSBundle.mainBundle().URLForResource("index", withExtension: "html", subdirectory: "Template")!
      let urlStringWithoutFragment = url.absoluteString.stringByReplacingOccurrencesOfString("#" + (url.fragment ?? ""), withString: "")
      if urlStringWithoutFragment == localPageURL.absoluteString {
        decisionHandler(.Allow)
      } else {
        decisionHandler(.Cancel)
        NSWorkspace.sharedWorkspace().openURL(url)
      }
    default:
      decisionHandler(.Allow)
    }
  }
}
