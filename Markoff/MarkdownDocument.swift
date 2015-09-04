import Cocoa
import ReactiveCocoa

class MarkdownDocument: NSDocument {
  typealias ObservableString = MutableProperty<String>
  let parser = MarkdownParser()
  var HTML = ObservableString("")

  var path: String {
    return fileURL?.path ?? ""
  }

  override class func autosavesInPlace() -> Bool {
    return true
  }

  override func makeWindowControllers() {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! WindowController
    addWindowController(windowController)
  }

  override func readFromURL(url: NSURL, ofType typeName: String) throws {
    convertToHTML()
    addToWatchedPaths()
    listenToChanges()
  }

  deinit {
    removeFromWatchedPaths()
  }

  private func convertToHTML() {
    parser.parse(path) { output in
      self.HTML.value = output
    }
  }

  private func listenToChanges() {
    let changeSignal = FileWatcher.eventSignal.filter { eventPath in
      self.path == eventPath
    }

    changeSignal.observe(next: { eventPath in
      self.convertToHTML()
    })
  }

  private func addToWatchedPaths() {
    FileWatcher.sharedWatcher.pathsToWatch.append(path)
  }

  private func removeFromWatchedPaths() {
    let watcher = FileWatcher.sharedWatcher

    if let index = watcher.pathsToWatch.indexOf(path) {
      watcher.pathsToWatch.removeAtIndex(index)
    }
  }
}

