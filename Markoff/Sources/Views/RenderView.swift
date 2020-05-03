import SwiftUI
import Combine
import WebKit

struct RenderView: View {
  @ObservedObject var viewModel: RenderViewModel

  init(_ viewModel: RenderViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    VStack(spacing: 0) {
      // Temporary hack to get the WebView to display the content properly.
      Rectangle().fill(Color(.windowBackgroundColor)).frame(height: 1)
      WebView(webView: viewModel.webViewStore.webView)
        .frame(minWidth: 600, minHeight: 400)

      HStack {
        Text(viewModel.metadata)
        Spacer()
        Text("Button")
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(BlurEffectView())
    }
  }
}

class RenderViewModel: NSObject, ObservableObject {
  var document: MarkdownDocument
  var webViewStore = WebViewStore()
  var cancellables = Set<AnyCancellable>()

  @Published var metadata: String = ""

  let templateURL = Bundle.main.url(
    forResource: "index",
    withExtension: "html",
    subdirectory: "Template"
  )!

  lazy var templateMarkup = {
    try! String(contentsOf: templateURL, encoding: .utf8)
  }()


  init(document: MarkdownDocument) {
    self.document = document
    super.init()
    self.setup()
  }

  private func setup() {
    webViewStore.webView.navigationDelegate = self

    document.markupUpdate
      .map { content in
        self.templateMarkup.replacingOccurrences(of: "$PLACEHOLDER", with: content)
      }
      .receive(on: DispatchQueue.main)
      .sink {
        self.webViewStore.update($0, baseURL: self.templateURL)
      }
      .store(in: &cancellables)

    document.sourceUpdate
      .map { markdown in
        "Words: \(markdown.wordCount) – Characters: \(markdown.count)"
      }
      .receive(on: DispatchQueue.main)
      .assign(to: \.metadata, on: self)
      .store(in: &cancellables)
  }
}

extension RenderViewModel: WKNavigationDelegate {
  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy
  ) -> Void) {

    switch navigationAction.navigationType {
    case .linkActivated:
      guard let url = navigationAction.request.url else { return }

      let localPageURL = Bundle.main.url(
        forResource: "index",
        withExtension: "html",
        subdirectory: "Template"
      )!

      let urlStringWithoutFragment = url.absoluteString.replacingOccurrences(
        of: "#" + (url.fragment ?? ""),
        with: ""
      )

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
