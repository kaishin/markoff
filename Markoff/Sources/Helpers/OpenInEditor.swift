import Foundation

func open(_ document: MarkdownDocument) {
  let userDefaults = UserDefaults.standard

  guard let path = userDefaults["defaultEditorPath"] as? String,
    let url = URL(string: path),
    let fileURL = document.fileURL as CFURL? else { return }

  let unmanagedAppURL = Unmanaged<CFURL>.passUnretained(url as CFURL)
  let itemURLs: CFArray = [fileURL] as CFArray
  let unmanagedItemsURLs = Unmanaged<CFArray>.passUnretained(itemURLs)

  var launchSpec = LSLaunchURLSpec(
    appURL: unmanagedAppURL,
    itemURLs: unmanagedItemsURLs,
    passThruParams: nil,
    launchFlags: LSLaunchFlags.defaults,
    asyncRefCon: nil
  )

  LSOpenFromURLSpec(&launchSpec, nil)
}
