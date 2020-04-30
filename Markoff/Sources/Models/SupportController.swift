import Cocoa

struct SupportController {
  let email = "markoff@hello.redalemeden.com"
  let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
  let systemVersion = ProcessInfo.processInfo.operatingSystemVersionString

  func contactSupport() {
    let subject = "Markoff Feedback - \(versionNumber) (\(buildNumber)) - \(systemVersion)"
    let escapedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

    if let escapedSubject = escapedSubject {
      if let supportURL = URL(string: "mailto:\(email)?&subject=\(escapedSubject)") {
        NSWorkspace.shared.open(supportURL)
      }
    }
  }
}
