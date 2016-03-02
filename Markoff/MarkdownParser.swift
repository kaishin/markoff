import Foundation
import SwiftMark

class MarkdownParser: NSObject {
  // MARK: - Private Properties
  let operationQueue = NSOperationQueue()

  private lazy var tempFileURL: NSURL = {
    let UUIDString = CFUUIDCreateString(nil, CFUUIDCreate(nil)) as String
    let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
    let fileURL = tempDirURL.URLByAppendingPathComponent(UUIDString)
    return fileURL
  }()

  // MARK: - Public Methods

  func parse(filePath: String, handler: String -> ()) {
    guard let markdown = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding) as String else {
      return handler("Parsing failed.")
    }

    let operation = SwiftMarkToHTMLOperation(text: transformFrontMatter(markdown))

    operation.conversionCompleteBlock = { html in
      handler(html)
    }

    operation.failureBlock = { error in
      handler("Parsing failed: \(error.hashValue)")
    }

    operationQueue.cancelAllOperations()
    operationQueue.addOperation(operation)
  }

  // MARK: - Lifecycle

  deinit {
    do {
      try NSFileManager.defaultManager().removeItemAtURL(tempFileURL)
    } catch { return }
  }

  // MARK: - Private Methods

  private func transformFrontMatter(markdown: String) -> String {
    let result = markdown =~ "^-{3}\n[\\s\\S]*?\n-{3}\n"
    if result.isMatching {
      let frontMatter = result.matches[0]
      let codeBlockString = frontMatter.stringByReplacingOccurrencesOfString("---", withString: "~~~")
      let hiddenMarkup = "<hr id='markoff-frontmatter-rule'>\n\n"
      return markdown.stringByReplacingOccurrencesOfString(frontMatter, withString: hiddenMarkup + codeBlockString)
    } else {
      return markdown
    }
  }
}


