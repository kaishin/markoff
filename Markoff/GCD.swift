import Foundation

public func onMain(_ block: @escaping ()->()) {
  if Thread.isMainThread {
    block()
  } else {
    DispatchQueue.main.async(execute: block)
  }
}
