import Foundation

class MarkdownParser: NSObject {
  let tempFileURL = temporaryFileURL()

  private var executableURL: NSURL {
    return NSBundle.mainBundle().URLForResource("cmark", withExtension: nil)!
  }

  func parse(filePath: String, handler: String -> ()) {
    writeTempFile(originalFilePath: filePath)

    let stdout = NSPipe()
    let task = try! NSUserUnixTask(URL: executableURL)
    task.standardOutput = stdout.fileHandleForWriting

    task.executeWithArguments([tempFileURL.path!], completionHandler: { _ in
      let outputData = stdout.fileHandleForReading.readDataToEndOfFile()
      let output = NSString(data: outputData, encoding: NSUTF8StringEncoding) as? String ?? "Parsing failed."
      handler(output)
    })
  }

  private func writeTempFile(originalFilePath path: String) -> Bool {
    guard let originalData = NSData(contentsOfFile: path),
      let originalString = NSString(data: originalData, encoding: NSUTF8StringEncoding) as? String,
      let sanitizedData = removeFrontMatter(originalString).dataUsingEncoding(NSUTF8StringEncoding) else { return false }

    return sanitizedData.writeToURL(tempFileURL, atomically: false)
  }

  deinit {
    do {
      try NSFileManager.defaultManager().removeItemAtURL(tempFileURL)
    } catch { return }
  }
}

private func temporaryFileURL() -> NSURL {
  let UUIDString = CFUUIDCreateString(nil, CFUUIDCreate(nil)) as String
  let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
  let tempFileURL = tempDirURL.URLByAppendingPathComponent(UUIDString)
  return tempFileURL
}

private func removeFrontMatter(markdown: String) -> String {
  let result = markdown =~ "-{3}[a-z]*\n[\\s\\S]*?\n-{3}"
  if result.isMatching {
    let frontMatter = result.matches[0]
    return markdown.stringByReplacingOccurrencesOfString(frontMatter, withString: "")
  } else {
    return markdown
  }
}
