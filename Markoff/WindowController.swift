import AppKit
import RxSwift
import RxSwiftExt
import RxCocoa
import Result

class WindowController: NSWindowController {
  let userDefaults = UserDefaults.standard

  @IBAction func openInEditor(_ sender: AnyObject) {
    guard let appCFURL = URL(string: userDefaults["defaultEditorPath"] as! String) as CFURL?,
      let markdownDocument = document as? MarkdownDocument,
      let fileURL = markdownDocument.fileURL as CFURL? else { return }
    
    let unmanagedAppURL = Unmanaged<CFURL>.passUnretained(appCFURL)
    let itemURLs: CFArray = [fileURL] as CFArray
    let unmanagedItemsURLs = Unmanaged<CFArray>.passUnretained(itemURLs)

    var launchSpec = LSLaunchURLSpec(appURL: unmanagedAppURL,
      itemURLs: unmanagedItemsURLs,
      passThruParams: nil,
      launchFlags: LSLaunchFlags.defaults,
      asyncRefCon: nil)

    LSOpenFromURLSpec(&launchSpec, nil)
  }

  var markdownDocument: MarkdownDocument? {
    return document as? MarkdownDocument
  }
}
