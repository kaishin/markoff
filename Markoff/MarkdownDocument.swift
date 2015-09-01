import Cocoa
import ReactiveCocoa

class MarkdownDocument: NSDocument {
  typealias ObservableString = MutableProperty<String>
  let parser = MarkdownParser()
  var HTML = ObservableString("")

  override class func autosavesInPlace() -> Bool {
    return true
  }

  override func makeWindowControllers() {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! WindowController
    addWindowController(windowController)
  }

  override func presentedItemDidChange() {
    super.presentedItemDidChange()
    convertToHTML()
  }

  override func readFromURL(url: NSURL, ofType typeName: String) throws {
    convertToHTML()
  }

  private func convertToHTML() {
    guard let path = fileURL?.path else { return }

    parser.parse(path) { output in
      self.HTML.value = output
    }
  }
}
