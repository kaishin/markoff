import Foundation

class Editor: NSObject {
  let name: String
  let path: URL

  init(name: String, path: URL) {
    self.path = path
    self.name = name
    super.init()
  }

  override var description: String {
    return name
  }
}
