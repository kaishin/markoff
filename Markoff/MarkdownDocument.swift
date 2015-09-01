import Cocoa

class MarkdownDocument: NSDocument {
  override class func autosavesInPlace() -> Bool {
    return true
  }

  override func makeWindowControllers() {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
    addWindowController(windowController)
  }

  override func presentedItemDidChange() {
    super.presentedItemDidChange()
  }

  override func readFromURL(url: NSURL, ofType typeName: String) throws {
  }
}

