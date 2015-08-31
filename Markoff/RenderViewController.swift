import Cocoa
import WebKit

class RenderViewController: NSViewController {
  var webView: WKWebView!
  let parser = MarkdownParser()

  override func viewDidLoad() {
    super.viewDidLoad()
    createWebView()
  }

  override var representedObject: AnyObject? {
    didSet {
      print("represented project did change")
    }
  }

  override func viewDidAppear() {
    if let doc = view.window?.windowController?.document as? MarkdownDocument, let fileName = doc.fileURL?.path {
      parser.run([fileName]) { output, error in
        let prelude = "<body style='font-family:\"Helvetica\"'>"
        let html = prelude + output![0] + "</body>"
        self.webView.loadHTMLString(html, baseURL: nil)
      }
    }
  }

  private func createWebView() {
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

