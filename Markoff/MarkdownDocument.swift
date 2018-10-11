import Cocoa
import ReactiveSwift

class MarkdownDocument: NSDocument {
  typealias ObservableString = MutableProperty<String>
  let parser = MarkdownParser()
  var HTML = ObservableString("")

  var path: String {
    return fileURL?.path ?? ""
  }

  override class var autosavesInPlace: Bool {
    return true
  }

  override func makeWindowControllers() {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! WindowController
    addWindowController(windowController)
  }

  override func read(from url: URL, ofType typeName: String) throws {
    convertToHTML()
    addToWatchedPaths()
    listenToChanges()
  }

  deinit {
    removeFromWatchedPaths()
  }

  fileprivate func convertToHTML() {
    parser.parse(path) { output in
      self.HTML.value = output
    }
  }

  fileprivate func listenToChanges() {
    let changeSignal = FileWatcher.eventSignal.filter { eventPath in
      self.path == eventPath
    }

    changeSignal.observeResult { eventPath in
      self.convertToHTML()
    }
  }

  fileprivate func addToWatchedPaths() {
    FileWatcher.sharedWatcher.pathsToWatch.append(path)
  }

  fileprivate func removeFromWatchedPaths() {
    let watcher = FileWatcher.sharedWatcher

    if let index = watcher.pathsToWatch.index(of: path) {
      watcher.pathsToWatch.remove(at: index)
    }
  }
}

