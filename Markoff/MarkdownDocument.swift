import Cocoa
import ReactiveCocoa
import WebKit

class MarkdownDocument: NSDocument {
  typealias ObservableString = MutableProperty<String>
  let parser = MarkdownParser()
  var HTML = ObservableString("")

  lazy var printView: WebView = {
    let view = WebView(frame: NSRect(x: 0, y: 0, width: 500, height: 800))
    view.frameLoadDelegate = self
    return view
  }()

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

  override func printDocument(sender: AnyObject?) {
    let viewModel = RenderViewModel(filePath: path, HTMLString: HTML.value)
    printView.mainFrame.loadHTMLString(viewModel.fullPageString, baseURL: viewModel.baseURL)
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

    changeSignal.observeNext { eventPath in
      self.convertToHTML()
    }
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

extension MarkdownDocument: WebFrameLoadDelegate {
  func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
    let printOperation = NSPrintOperation(view: printView, printInfo: printInfo)
    printOperation.showsPrintPanel = true
    printOperation.runOperation()
  }
}

