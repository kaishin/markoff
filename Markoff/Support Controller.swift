import Cocoa

struct SupportController {
  let email = "markoff@thoughtbot.com"
  let versionNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
  let buildNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
  let systemVersion = NSProcessInfo.processInfo().operatingSystemVersionString

  func contactSupport() {
    let subject = "Markoff Feedback - \(versionNumber) (\(buildNumber)) - \(systemVersion)"
    let escapedSubject = subject.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())

    if let escapedSubject = escapedSubject {
      if let supportURL = NSURL(string: "mailto:\(email)?&subject=\(escapedSubject)") {
        NSWorkspace.sharedWorkspace().openURL(supportURL)
      }
    }
  }
}
