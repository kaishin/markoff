import Foundation
import Combine

class FileWatcher {
  let fileEvent = PassthroughSubject<String, Never>()

  static let shared = FileWatcher()

  var pathsToWatch: [String] = [""] {
    didSet { restart() }
  }

  private var started = false
  private var stream: FSEventStreamRef?
  private var lastEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow)

  private let eventCallback: FSEventStreamCallback = { (stream, contextInfo, numEvents, eventPaths, eventFlags, eventIds) in
    guard let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] else { return }
    FileWatcher.shared.fileEvent.send(paths[0])
  }

  deinit {
    stop()
  }

  func start() {
    guard started == false else { return }

    var context = FSEventStreamContext(
      version: 0,
      info: Unmanaged.passUnretained(self).toOpaque(),
      retain: nil,
      release: nil,
      copyDescription: nil
    )
    let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
    self.stream = FSEventStreamCreate(kCFAllocatorDefault, eventCallback, &context, pathsToWatch as CFArray, lastEventId, 0, flags)

    guard let stream = self.stream else { return }

    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
    FSEventStreamStart(stream)
    started = true
  }

  func stop() {
    guard started == true, let stream = self.stream else { return }

    FSEventStreamStop(stream)
    FSEventStreamInvalidate(stream)
    FSEventStreamRelease(stream)
    self.stream = nil
    started = false
  }

  private func restart() {
    stop()
    start()
  }
}

