import Foundation

struct RenderViewModel {
  let fullPageString: String
  let baseURL: NSURL

  init(HTMLString: String) {
    baseURL = NSBundle.mainBundle().URLForResource("index", withExtension: "html", subdirectory: "Template")!
    let templateContent = try! NSString(contentsOfURL: baseURL, encoding: NSUTF8StringEncoding)
    fullPageString = templateContent.stringByReplacingOccurrencesOfString("$PLACEHOLDER", withString: HTMLString)
  }

  var metadata: String {
    return "Words: \(fullPageString.wordCount) – Characters: \(fullPageString.characterCount)"
  }
}
