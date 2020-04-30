import Cocoa
import WebKit

class RenderViewController: NSViewController {
//  var disposeBag = DisposeBag()
  @IBOutlet weak var openButton: NSButton!
  @IBOutlet weak var metadataLabel: NSTextField!

  lazy var webView: WebView = {
    return WebView(frame: self.view.bounds)
  }()

  var viewModel: ViewModel! {
    didSet {
      bindViewModel()
    }
  }

  private func bindViewModel() {
//    viewModel.fullPageMarkup.drive(onNext: { markup in
//      self.webView.update(markup, baseURL: ViewModel.templateURL)
//    }).disposed(by: disposeBag)
//
//    viewModel.metadata.drive(metadataLabel.rx.text)
//      .disposed(by: disposeBag)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
    openButton.toolTip = "Open with \(PreferencesController().defaultEditor.name)"
  }

  override func viewDidAppear() {
    super.viewDidAppear()
    registerWindowName()
    bindViewModel()
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
    guard let window = view.window else { return }
    window.setFrameAutosaveName(viewModel.filePath)
  }
}

extension RenderViewController {
  final class ViewModel: NSObject {
//    var disposeBag = DisposeBag()
    let filePath: String
//    let fullPageMarkup: Driver<String>
//    let metadata: Driver<String>


    init(document: MarkdownDocument) {
      self.filePath = document.path
//      self.fullPageMarkup = document.markupUpdate.map( { contentMarkup in
//        return ViewModel.templateMarkup.replacingOccurrences(of: "$PLACEHOLDER", with: contentMarkup)
//      }).asDriver(onErrorJustReturn: "A parsing error occured.")

//      self.metadata = document.sourceUpdate.map({ markdown in
//        return "Words: \(markdown.wordCount) – Characters: \(markdown.count)"
//      }).asDriver(onErrorJustReturn: "—")
    }

    static let templateURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Template")!
    static let templateMarkup = try! String(contentsOf: ViewModel.templateURL, encoding: .utf8)
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
