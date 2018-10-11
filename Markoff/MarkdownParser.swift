import Foundation
import Down

class MarkdownParser: NSObject {
  // MARK: - Private Properties
  fileprivate lazy var tempFileURL: URL = {
    let UUIDString = CFUUIDCreateString(nil, CFUUIDCreate(nil)) as String
    let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory())
    let fileURL = tempDirURL.appendingPathComponent(UUIDString)
    return fileURL
  }()

  // MARK: - Public Methods

  func parse(_ filePath: String, handler: @escaping (String) -> ()) {
    guard let markdown = try? NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) as String else {
      return handler("Parsing failed.")
    }

    let down = Down(markdownString: transformFrontMatter(markdown))

    do {
      let html = try down.toHTML()
      handler(html)
    } catch let error {
      handler("Parsing failed: \(error.localizedDescription)")
    }
  }

  // MARK: - Lifecycle

  deinit {
    do {
      try FileManager.default.removeItem(at: tempFileURL)
    } catch { return }
  }

  // MARK: - Private Methods

  fileprivate func transformFrontMatter(_ markdown: String) -> String {
    let result = markdown =~ "^-{3}\n[\\s\\S]*?\n-{3}\n"
    if result.isMatching {
      let frontMatter = result.matches[0]
      let codeBlockString = frontMatter.replacingOccurrences(of: "---", with: "~~~")
      let hiddenMarkup = "<hr id='markoff-frontmatter-rule'>\n\n"
      return markdown.replacingOccurrences(of: frontMatter, with: hiddenMarkup + codeBlockString)
    } else {
      return markdown
    }
  }
}


