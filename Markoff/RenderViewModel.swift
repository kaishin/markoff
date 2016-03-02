import Foundation

struct RenderViewModel {
  let fullPageString: String
  let baseURL: NSURL
  let filePath: String

  init(filePath path: String, HTMLString: String) {
    baseURL = NSBundle.mainBundle().URLForResource("index", withExtension: "html", subdirectory: "Template")!
    let templateContent = try! NSString(contentsOfURL: baseURL, encoding: NSUTF8StringEncoding)
    fullPageString = templateContent.stringByReplacingOccurrencesOfString("$PLACEHOLDER", withString: HTMLString)
    filePath = path
  }

  init(document: MarkdownDocument) {
    self.init(filePath: document.path, HTMLString: document.HTML.value)
  }

  var metadata: String {
    guard let markdown = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding) as String else {
      return ""
    }

    return "Words: \(markdown.wordCount) – Characters: \(markdown.characters.count)"
  }
}
