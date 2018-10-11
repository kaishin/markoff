import Foundation
import ReactiveCocoa
import Result

open class FileWatcher {
  open static let (eventSignal, eventSink) = Signal<String, NoError>.pipe()
  open static let sharedWatcher = FileWatcher()
  open var pathsToWatch: [String] = [""] {
    didSet { restart() }
  }

  fileprivate var started = false
  fileprivate var stream: FSEventStreamRef!
  fileprivate var lastEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow)

  fileprivate let eventCallback: FSEventStreamCallback = {(
    stream: ConstFSEventStreamRef,
    contextInfo: UnsafeMutableRawPointer,
    numEvents: Int,
    eventPaths: UnsafeMutableRawPointer,
    eventFlags: UnsafePointer<FSEventStreamEventFlags>,
    eventIds: UnsafePointer<FSEventStreamEventId>
    ) in

    if let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] {
      FileWatcher.eventSink.sendNext(paths[0])
    }
  } as! FSEventStreamCallback

  deinit {
    stop()
  }

  open func start() {
    guard started == false else { return }

    var info = self
    var context = FSEventStreamContext(version: 0, info: &info, retain: nil, release: nil, copyDescription: nil)
    let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
    stream = FSEventStreamCreate(kCFAllocatorDefault, eventCallback, &context, pathsToWatch as CFArray, lastEventId, 0, flags)
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetMain(), CFRunLoopMode.defaultMode)
    FSEventStreamStart(stream)
    started = true
  }

  open func stop() {
    guard started == true else { return }

    FSEventStreamStop(stream)
    FSEventStreamInvalidate(stream)
    FSEventStreamRelease(stream)
    stream = nil
    started = false
  }

  fileprivate func restart() {
    stop()
    start()
  }
}

