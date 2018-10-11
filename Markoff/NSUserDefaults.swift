import Foundation

extension UserDefaults {
  subscript(key: String) -> AnyObject? {
    get {
      return self.object(forKey: key) as AnyObject
    }
    
    set(newValue) {
      self.set(newValue, forKey: key)
    }
  }
}
