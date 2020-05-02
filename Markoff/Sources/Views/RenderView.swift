import SwiftUI
import Combine

struct RenderView: View {
  @ObservedObject var store: RenderViewStore

  init(_ store: RenderViewStore) {
    self.store = store
  }

  var body: some View {
    ZStack {
      WebView(webView: store.webViewStore.webView)

//      Text(store.document.path)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}


class RenderViewStore: ObservableObject {
  var document: MarkdownDocument
  var webViewStore = WebViewStore()
  var cancellables = Set<AnyCancellable>()

  @Published var markup: String = ""
  @Published var metadata: String = ""

  let templateURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Template")!

  lazy var templateMarkup = {
    try! String(contentsOf: templateURL, encoding: .utf8)
  }()


  init(document: MarkdownDocument) {
    self.document = document

    document.markupUpdate
      .map { html in
        "Words"
      }
      .assign(to: \.markup, on: self)
      .store(in: &cancellables)

    document.sourceUpdate
      .map { markdown in
        "Words: \(markdown.wordCount) – Characters: \(markdown.count)"
      }
      .assign(to: \.metadata, on: self)
      .store(in: &cancellables)

    document.markupUpdate
      .sink {
        self.webViewStore.update($0, baseURL: self.templateURL)
      }
      .store(in: &cancellables)
  }

}

//struct RenderView_Previews: PreviewProvider {
//  static var previews: some View {
//    RenderView()
//  }
//}
