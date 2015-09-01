import Cocoa
import WebKit

class RenderViewController: NSViewController {
  var webView: WKWebView!
  let parser = MarkdownParser()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
  }

  override var representedObject: AnyObject? {
    didSet {
      print("represented project did change")
    }
  }

  override func viewDidAppear() {
    if let doc = view.window?.windowController?.document as? MarkdownDocument, let filePath = doc.fileURL?.path {
      parser.parse(filePath) { output in
        let prelude = "<body style='font-family:\"Helvetica\"'>"
        let html = prelude + output + "</body>"
        self.webView.loadHTMLString(html, baseURL: nil)
      }
    }
  }

  private func setupWebView() {
    webView = WKWebView(frame: view.bounds, configuration: WKWebViewConfiguration())
    view.addSubview(webView)
    webView.translatesAutoresizingMaskIntoConstraints = false

    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|",
      options: NSLayoutFormatOptions(),
      metrics: nil,
      views: ["webView": webView]))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|",
      options: NSLayoutFormatOptions(),
      metrics: nil,
      views: ["webView": webView]))
  }
}

