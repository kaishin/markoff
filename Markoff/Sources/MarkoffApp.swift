import SwiftUI

@main
struct MarkoffApp: App {
  var body: some Scene {
    DocumentGroup(viewing: MarkdownDocument.self) { config in
      DocumentView(
        store:
          .init(
            initialState: .init(config),
            reducer: Document.reducer,
            environment: ()
          )
      )
    }
  }
}
