import AppKit
import ReactiveCocoa
import Result

class WindowController: NSWindowController {
  let (documentChangeSignal, documentChangeSink) = Signal<String, NoError>.pipe()

  override var document: AnyObject? {
    didSet {
      guard let markdownDocument = markdownDocument else { return }
      markdownDocument.HTML.producer.start(documentChangeSink)
    }
  }

  var markdownDocument: MarkdownDocument? {
    return document as? MarkdownDocument
  }
}
