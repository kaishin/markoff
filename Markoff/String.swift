import Foundation

extension String {
  var wordCount: Int {
    return self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).count
  }
}
