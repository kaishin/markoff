import Foundation

class Editor: NSObject {
  let name: String
  let path: NSURL

  init(name: String, path: NSURL) {
    self.path = path
    self.name = name
    super.init()
  }

  override var description: String {
    return name
  }
}
