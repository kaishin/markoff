import Foundation

class MarkdownParser: NSObject {
  // MARK: - Private Properties

  private lazy var tempFileURL: NSURL = {
    let UUIDString = CFUUIDCreateString(nil, CFUUIDCreate(nil)) as String
    let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
    let fileURL = tempDirURL.URLByAppendingPathComponent(UUIDString)
    return fileURL
  }()

  // MARK: - Public Methods

  func parse(filePath: String, handler: String -> ()) {
    writeTempFile(originalFilePath: filePath)

    let task = NSTask()
    task.arguments = [tempFileURL.path!, "--smart"]
    task.standardOutput = NSPipe()
    task.launchPath = NSBundle.mainBundle().pathForResource("cmark", ofType: "")!

    task.terminationHandler = { task in
      guard let outputData = task.standardOutput?.fileHandleForReading.readDataToEndOfFile(),
        let output = NSString(data: outputData, encoding: NSUTF8StringEncoding) as? String else {
          handler("Parsing failed.")
          return
      }

      handler(output)
    }

    task.launch()
  }

  // MARK: - Lifecycle

  deinit {
    do {
      try NSFileManager.defaultManager().removeItemAtURL(tempFileURL)
    } catch { return }
  }

  // MARK: - Private Methods

  private func writeTempFile(originalFilePath path: String) -> Bool {
    guard let originalData = NSData(contentsOfFile: path),
      let originalString = NSString(data: originalData, encoding: NSUTF8StringEncoding) as? String,
      let sanitizedData = transformFrontMatter(originalString).dataUsingEncoding(NSUTF8StringEncoding) else { return false }

    return sanitizedData.writeToURL(tempFileURL, atomically: false)
  }

  private func transformFrontMatter(markdown: String) -> String {
    let result = markdown =~ "-{3}[a-z]*\n[\\s\\S]*?\n-{3}"
    if result.isMatching {
      let frontMatter = result.matches[0]
      let codeBlockString = frontMatter.stringByReplacingOccurrencesOfString("---", withString: "~~~")
      return markdown.stringByReplacingOccurrencesOfString(frontMatter, withString: codeBlockString)
    } else {
      return markdown
    }
  }
}


