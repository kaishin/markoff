import Foundation

infix operator =~

func =~ (value: String, pattern: String) -> RegexResult {
  let string = value as NSString
  let options = NSRegularExpression.Options(rawValue: 0)

  guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
    return RegexResult(results: [])
  }

  let all = NSRange(location: 0, length: string.length)
  let matchingOptions = NSRegularExpression.MatchingOptions(rawValue: 0)
  var matches: [String] = []

  regex.enumerateMatches(in: value, options: matchingOptions, range: all) {
    (result, flags, pointer) in
    let string = string.substring(with: result!.range)
    matches.append(string)
  }

  return RegexResult(results: matches)
}

struct RegexResult {
  let isMatching: Bool
  let matches: [String]

  init(results: [String]) {
    matches = results
    isMatching = matches.count > 0
  }
}
