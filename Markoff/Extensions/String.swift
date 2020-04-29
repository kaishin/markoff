import Foundation

extension String {
  var wordCount: Int {
    return self.components(separatedBy: CharacterSet.whitespaces).count
  }
}
