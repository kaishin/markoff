import Combine
import SwiftUI
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

func css() -> String {
  let url = Bundle.main.url(forResource: "styles", withExtension: "css")
  return try! String(contentsOf: url!)
}

let template = """
<!DOCTYPE html>
<html>
  <head>
    <title>Preview</title>
    <meta charset="utf-8">
    <script src="scripts/vendor.js" type="text/javascript" charset="utf-8"></script>
    <script src="scripts/main.js" type="text/javascript" charset="utf-8"></script>
    <style type="text/css">
    \(css())
    </style>
  </head>
  <body>
   <main>$PLACEHOLDER</main>
  </body>
</html>
"""

class RenderViewModel: NSObject, ObservableObject {
  var document: MarkdownDocument
  var webViewStore = WebViewStore()
  var cancellables = Set<AnyCancellable>()

  @Published var metadata: String = ""

  init(document: MarkdownDocument) {
    self.document = document
    super.init()
    setup()
  }

  private func setup() {
    webViewStore.webView.navigationDelegate = self

    document.markupUpdate
      .map { content in
        template
          .replacingOccurrences(of: "$PLACEHOLDER", with: content)
      }
      .receive(on: DispatchQueue.main)
      .sink {
        self.webViewStore.update($0)
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
    _: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy
    ) -> Void
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
