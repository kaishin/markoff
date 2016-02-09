import Foundation

public func onMain(block: dispatch_block_t) {
  if NSThread.isMainThread() {
    block()
  } else {
    dispatch_async(dispatch_get_main_queue(), block)
  }
}
