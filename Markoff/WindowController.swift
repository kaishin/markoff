import AppKit
import RxSwift
import RxSwiftExt
import RxCocoa
import Result

class WindowController: NSWindowController {
  var disposeBag = DisposeBag()
  let userDefaults = UserDefaults.standard
  let documentChangeSignal = PublishSubject<String>()

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

  override var document: AnyObject? {
    didSet {
      guard let markdownDocument = markdownDocument else { return }
      documentChangeSignal.onNext(markdownDocument.path)
      markdownDocument.HTML
        .bind(to: documentChangeSignal)
        .disposed(by: disposeBag)
//      markdownDocument.HTML.producer.start(documentChangeSink)
    }
  }

  var markdownDocument: MarkdownDocument? {
    return document as? MarkdownDocument
  }
}
