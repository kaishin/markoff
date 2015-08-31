import Foundation

class MarkdownParser: NSObject {
  private var executableURL: NSURL {
    return NSBundle.mainBundle().URLForResource("cmark", withExtension: nil)!
  }

  func run(input: [String]?, handler: ([String]?, NSError?) -> ()) {
    execute(executableURL, input: input, handler: handler)
  }
}

func execute(executableURL: NSURL, input: [String]?, handler: ([String]?, NSError?) -> ()) {
  let stdout = NSPipe()
  let stderr = NSPipe()

  let task = try! NSUserUnixTask(URL: executableURL)
  task.standardOutput = stdout.fileHandleForWriting
  task.standardError = stderr.fileHandleForWriting

  task.executeWithArguments(input, completionHandler: { (error) -> Void in
    let output = stdout.fileHandleForReading.readDataToEndOfFile()
    let error = stderr.fileHandleForReading.readDataToEndOfFile()
    let outputString = NSString(data: output, encoding: NSUTF8StringEncoding) as? String ?? ""
    let errorString = NSString(data: error, encoding: NSUTF8StringEncoding) as? String ?? ""
    handler([outputString, errorString], .None)
  })
}