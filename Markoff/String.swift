import Foundation

extension String {
  var wordCount: Int {
    return stripHTML().componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).count
  }

  var characterCount: Int {
    return stripHTML().characters.count
  }

  private func stripHTML() -> String {
    return find("<[^>]*>", replaceWith: "")
      .find(" +", replaceWith: " ")
  }

  private func find(pattern: String, replaceWith newString: String) -> String {
    let result = self =~ pattern
    return result.matches.reduce(self) { string, stringToRemove in
      return string.stringByReplacingOccurrencesOfString(stringToRemove, withString: newString)
    }
  }
}
