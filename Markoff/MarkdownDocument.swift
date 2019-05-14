import Cocoa
import RxSwift
import RxSwiftExt
import RxCocoa

class MarkdownDocument: NSDocument {
  var disposeBag = DisposeBag()
  let parser = MarkdownParser()
  var markupUpdate = BehaviorSubject(value: "")

  var path: String {
    return fileURL?.path ?? ""
  }

  override init() {
    super.init()
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

  private func convertToHTML() {
    parser.parse(path) { output in
      self.markupUpdate.onNext(output)
    }
  }

  private func listenToChanges() {
    FileWatcher.shared.fileEvent
      .filter { eventPath in
        self.path == eventPath
      }
      .map { [weak self] path in
        return self?.parser.parse(path)
      }
      .unwrap()
      .bind(to: markupUpdate)
      .disposed(by: disposeBag)
  }

  private func addToWatchedPaths() {
    FileWatcher.shared.pathsToWatch.append(path)
  }

  private func removeFromWatchedPaths() {
    let watcher = FileWatcher.shared

    if let index = watcher.pathsToWatch.firstIndex(of: path) {
      watcher.pathsToWatch.remove(at: index)
    }
  }
}

