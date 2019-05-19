import Cocoa
import RxSwift
import RxSwiftExt
import RxCocoa

class MarkdownDocument: NSDocument {
  var disposeBag = DisposeBag()
  let parser = MarkdownParser()
  var markupUpdate = BehaviorSubject(value: "")
  var sourceUpdate = BehaviorSubject(value: "")

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
    addWindowController(WindowController.loadFromStoryboard())
  }

  override func read(from url: URL, ofType typeName: String) throws {
    self.markupUpdate.onNext(parser.parse(path))
    addToWatchedPaths()
    listenToChanges()
  }

  deinit {
    removeFromWatchedPaths()
  }

  private func listenToChanges() {
    FileWatcher.shared.fileEvent
      .filter { eventPath in
        self.path == eventPath
      }
      .map { path in
        return try? String(contentsOfFile: path, encoding: .utf8)
      }
      .unwrap()
      .bind(to: sourceUpdate)
      .disposed(by: disposeBag)

    sourceUpdate
      .map { [unowned self] markdown in
        return self.parser.parse(markdown)
      }
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

