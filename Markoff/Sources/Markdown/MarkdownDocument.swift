import SwiftUI
import UniformTypeIdentifiers

extension UTType {
  static var markdown: UTType {
    UTType(importedAs: "net.daringfireball.markdown")
  }
}

struct MarkdownDocument: FileDocument {
  var raw: String
  var html: String
  
  static var readableContentTypes: [UTType] { [.markdown, .plainText] }
  
  init(fileWrapper: FileWrapper, contentType: UTType) throws {
    guard let data = fileWrapper.regularFileContents,
          let raw = String(data: data, encoding: .utf8)
    else {
      throw CocoaError(.fileReadCorruptFile)
    }
    
    self.raw = raw
    self.html = MarkdownParser.parse(raw)
  }
  
  func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {}
}
