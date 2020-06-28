import SwiftUI

@main
struct MarkoffApp: App {
  var body: some Scene {
    DocumentGroup(viewing: MarkdownDocument.self) { config in
      MarkupRenderView(
        store:
          .init(
            initialState: .init(config),
            reducer: MarkupRender.reducer,
            environment: ()
          )
      )
    }
  }
}
