import Cocoa
import WebKit
import RxSwift
import RxSwiftExt
import RxCocoa

class RenderViewController: NSViewController {
  var disposeBag = DisposeBag()
  @IBOutlet weak var openButton: NSButton!
  @IBOutlet weak var metadataLabel: NSTextField!

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

  private var markdownDocument: MarkdownDocument? {
    return view.window?.windowController?.document as? MarkdownDocument
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

    guard let document = markdownDocument else { return }
    self.viewModel = RenderViewModel(document: document)
  }

  private func listenToDocumentChangeSignal() {
    markdownDocument?.markupUpdate.asDriver(onErrorJustReturn: "Error").drive(onNext: { output in
      guard let document = self.markdownDocument else { return }
      self.viewModel = RenderViewModel(filePath: document.path, HTMLString: output)
    }).disposed(by: disposeBag)
  }

  private func setupWebView() {
    view.addSubview(webView, positioned: .below, relativeTo: view.subviews[0])
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.navigationDelegate = self

    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|",
      options: NSLayoutConstraint.FormatOptions(),
      metrics: nil,
      views: ["webView": webView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|",
      options: NSLayoutConstraint.FormatOptions(),
      metrics: nil,
      views: ["webView": webView]))
  }

  private func registerWindowName() {
    guard let window = view.window,
      let document = markdownDocument
      else { return }
    window.setFrameAutosaveName(document.path)
  }
}

extension RenderViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    switch navigationAction.navigationType {
    case .linkActivated:
      guard let url = navigationAction.request.url else { return }
      let localPageURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Template")!
      let urlStringWithoutFragment = url.absoluteString.replacingOccurrences(of: "#" + (url.fragment ?? ""), with: "")
      if urlStringWithoutFragment == localPageURL.absoluteString {
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

extension RenderViewController {
  final class ViewModel: NSObject {
    internal init(fullPageString: String, baseURL: URL, filePath: String) {
      self.fullPageString = fullPageString
      self.baseURL = baseURL
      self.filePath = filePath
    }

    let fullPageString: String
    let baseURL: URL
    let filePath: String
  }
}

