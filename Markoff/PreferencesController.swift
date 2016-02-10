import Foundation

class PreferencesController {
  let defaults = NSUserDefaults.standardUserDefaults()

  lazy var editors: [Editor] = {
    let URL = NSBundle.mainBundle().URLForResource("sample", withExtension: "md", subdirectory: "Template")!
    let editorURLArray = LSCopyApplicationURLsForURL(URL as CFURL, LSRolesMask.Editor)!.takeUnretainedValue() as NSArray
    let editorURLs = editorURLArray as? [NSURL] ?? []

    return editorURLs.map { URL in
      let applicationName: String = (try? URL.resourceValuesForKeys([NSURLLocalizedNameKey])[NSURLLocalizedNameKey]) as? String ?? "Unknown Editor"
      return Editor(name: applicationName, path: URL)
    }
  }()

  var defaultEditor: Editor {
    get {
      guard let defaultPath = defaults["defaultEditorPath"] as? String,
        let defaultEditor = (editors.filter { $0.path.absoluteString == defaultPath }).first
        else { return editors.first! }

      return defaultEditor
    }

    set {
      defaults["defaultEditorPath"] = newValue.path.absoluteString
    }
  }

  func registerDefaults() {
    guard let defaultEditor = editors.last else { return }
    defaults.registerDefaults(["defaultEditorPath": defaultEditor.path.absoluteString])
  }
}
