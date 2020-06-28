import ComposableArchitecture
import SwiftUI

enum MarkupRender {
  typealias Environemnt = ()

  struct State: Equatable {
    var documentConfig: FileDocumentConfiguration<MarkdownDocument>

    internal init(_ documentConfig: FileDocumentConfiguration<MarkdownDocument>) {
      self.documentConfig = documentConfig
    }

    var metadata: String {
      let markdown = documentConfig.document.raw
      return "Words: \(markdown.wordCount) – Characters: \(markdown.count)"
    }

    var html: String {
      return template.replacingOccurrences(
        of: "$PLACEHOLDER",
        with: documentConfig.document.html
      )
    }

    var fileURL: URL? {
      return documentConfig.fileURL
    }

    static func == (lhs: MarkupRender.State, rhs: MarkupRender.State) -> Bool {
      lhs.documentConfig.fileURL == rhs.documentConfig.fileURL
    }
  }

  enum Action {
    case setUp
  }

  static var reducer: Reducer<State, Action, Environemnt> {
    .init { action, state, env in
      return .none
    }
  }
}

