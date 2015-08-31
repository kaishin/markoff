import Foundation

class MarkdownParser: NSObject {
  private var executableURL: NSURL {
    return NSBundle.mainBundle().URLForResource("cmark", withExtension: nil)!
  }

  func parse(filePath: String, handler: String -> ()) {
    let stdout = NSPipe()
    let task = try! NSUserUnixTask(URL: executableURL)
    task.standardOutput = stdout.fileHandleForWriting

    task.executeWithArguments([filePath], completionHandler: { _ in
      let outputData = stdout.fileHandleForReading.readDataToEndOfFile()
      let output = NSString(data: outputData, encoding: NSUTF8StringEncoding) as? String ?? "Parsing failed."
      handler(output)
    })
  }
}
