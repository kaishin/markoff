import AppKit

class WindowController: NSWindowController {
  let userDefaults = UserDefaults.standard

  @IBAction func openInEditor(_ sender: AnyObject) {
    guard let document = markdownDocument else { return }
    open(document)
  }

  var markdownDocument: MarkdownDocument? {
    return document as? MarkdownDocument
  }
}
