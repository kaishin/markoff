import Foundation
import Down

class MarkdownParser: NSObject {
  // MARK: - Private Properties
  private lazy var tempFileURL: URL = {
    let UUIDString = CFUUIDCreateString(nil, CFUUIDCreate(nil)) as String
    let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory())
    let fileURL = tempDirURL.appendingPathComponent(UUIDString)
    return fileURL
  }()

  // MARK: - Public Methods
  func parse(_ markdown: String) -> String {
    let down = Down(markdownString: transformFrontMatter(markdown))

    do {
      return try down.toHTML()
    } catch let error {
      return "Parsing failed: \(error.localizedDescription)"
    }
  }

  // MARK: - Lifecycle

  deinit {
    do {
      try FileManager.default.removeItem(at: tempFileURL)
    } catch { return }
  }

  // MARK: - Private Methods

  private func transformFrontMatter(_ markdown: String) -> String {
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


