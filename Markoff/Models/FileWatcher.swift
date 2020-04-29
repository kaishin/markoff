import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import Result

public class FileWatcher {
  let fileEvent = PublishSubject<String>()

  public static let shared = FileWatcher()

  public var pathsToWatch: [String] = [""] {
    didSet { restart() }
  }

  private var started = false
  private var stream: FSEventStreamRef!
  private var lastEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow)

  private let eventCallback: FSEventStreamCallback = { (stream, contextInfo, numEvents, eventPaths, eventFlags, eventIds) in
    guard let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] else { return }
    FileWatcher.shared.fileEvent.onNext(paths[0])
  }


  deinit {
    stop()
  }

  public func start() {
    guard started == false else { return }

    var info = self
    var context = FSEventStreamContext(version: 0, info: &info, retain: nil, release: nil, copyDescription: nil)
    let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
    stream = FSEventStreamCreate(kCFAllocatorDefault, eventCallback, &context, pathsToWatch as CFArray, lastEventId, 0, flags)
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
    FSEventStreamStart(stream)
    started = true
  }

  public func stop() {
    guard started == true else { return }

    FSEventStreamStop(stream)
    FSEventStreamInvalidate(stream)
    FSEventStreamRelease(stream)
    stream = nil
    started = false
  }

  private func restart() {
    stop()
    start()
  }
}

