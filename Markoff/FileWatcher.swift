import Foundation
import ReactiveCocoa
import Result

public class FileWatcher {
  public static let (eventSignal, eventSink) = Signal<String, NoError>.pipe()
  public static let sharedWatcher = FileWatcher()
  public var pathsToWatch: [String] = [""] {
    didSet { restart() }
  }

  private var started = false
  private var stream: FSEventStreamRef!
  private var lastEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow)

  private let eventCallback: FSEventStreamCallback = {(
    stream: ConstFSEventStreamRef,
    contextInfo: UnsafeMutablePointer<Void>,
    numEvents: Int,
    eventPaths: UnsafeMutablePointer<Void>,
    eventFlags: UnsafePointer<FSEventStreamEventFlags>,
    eventIds: UnsafePointer<FSEventStreamEventId>
    ) in

    if let paths = unsafeBitCast(eventPaths, NSArray.self) as? [String] {
      FileWatcher.eventSink.sendNext(paths[0])
    }
  }

  deinit {
    stop()
  }

  public func start() {
    guard started == false else { return }

    var info = self
    var context = FSEventStreamContext(version: 0, info: &info, retain: nil, release: nil, copyDescription: nil)
    let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
    stream = FSEventStreamCreate(kCFAllocatorDefault, eventCallback, &context, pathsToWatch, lastEventId, 0, flags)
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetMain(), kCFRunLoopDefaultMode)
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

