import CommonMark
import Foundation

enum MarkdownParser {
  static func parse(_ markdown: String) -> String {
    do {
      let document = try CommonMark.Document(transformFrontMatter(markdown))
      return document.render(format: .html)
    } catch let error {
      return "Parsing failed: \(error.localizedDescription)"
    }
  }

  private static func transformFrontMatter(_ markdown: String) -> String {
    let result = markdown =~ "^-{3}\n[\\s\\S]*?\n-{3}\n"
    if result.isMatching {
      let frontMatter = result.matches[0]
      let codeBlockString = frontMatter.replacingOccurrences(of: "---", with: "~~~")
      let hiddenMarkup = "<hr id='markoff-frontmatter-rule'>\n\n"
      return markdown.replacingOccurrences(of: frontMatter, with: hiddenMarkup + codeBlockString)
    } else {
      return markdown
    }
  }
}

func css() -> String {
  let url = Bundle.main.url(forResource: "styles", withExtension: "css")
  return try! String(contentsOf: url!)
}

let template = """
<!DOCTYPE html>
<html>
  <head>
    <title>Preview</title>
    <meta charset="utf-8">
    <script src="scripts/vendor.js" type="text/javascript" charset="utf-8"></script>
    <script src="scripts/main.js" type="text/javascript" charset="utf-8"></script>
    <style type="text/css">
    \(css())
    </style>
  </head>
  <body>
   <main>$PLACEHOLDER</main>
  </body>
</html>
"""

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
