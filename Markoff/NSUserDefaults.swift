import Foundation

extension NSUserDefaults {
  subscript(key: String) -> AnyObject? {
    get {
      return self.objectForKey(key)
    }
    
    set(newValue) {
      self.setObject(newValue, forKey: key)
    }
  }
}
