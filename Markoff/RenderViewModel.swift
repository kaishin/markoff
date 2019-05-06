import Foundation

struct RenderViewModel {
  let fullPageString: String
  let baseURL: URL
  let filePath: String

  init(filePath path: String, HTMLString: String) {
    baseURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Template")!
    let templateContent = try! NSString(contentsOf: baseURL, encoding: String.Encoding.utf8.rawValue)
    fullPageString = templateContent.replacingOccurrences(of: "$PLACEHOLDER", with: HTMLString)
    filePath = path
  }

  init(document: MarkdownDocument) {
    self.init(filePath: document.path, HTMLString: (try? document.HTML.value()) ?? "ERROR")
  }

  var metadata: String {
    guard let markdown = try? NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) as String else {
      return ""
    }

    return "Words: \(markdown.wordCount) – Characters: \(markdown.count)"
  }
}
