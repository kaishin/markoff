import AppKit
import ReactiveCocoa

class WindowController: NSWindowController {
  let (documentChangeSignal, documentChangeSink) = Signal<String, NoError>.pipe()

  override var document: AnyObject? {
    didSet {
      guard let markdownDocument = document as? MarkdownDocument else { return }

      markdownDocument.HTML.producer.on(next: { HTML in
        self.documentChangeSink.sendNext(HTML)
      }).start()
    }
  }

  var markdownDocument: MarkdownDocument? {
    return document as? MarkdownDocument
  }
}
