import Foundation

class PreferencesController {
  let defaults = NSUserDefaults.standardUserDefaults()

  lazy var editors: [Editor] = {
    let editorURLArray = LSCopyApplicationURLsForURL(self.sampleFileURL as CFURL, LSRolesMask.Editor)!.takeUnretainedValue() as NSArray
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
      defaults["defaultEditorName"] = newValue.name
    }
  }

  private lazy var sampleFileURL: NSURL = {
    return NSBundle.mainBundle().URLForResource("sample", withExtension: "md", subdirectory: "Template")!
  }()

  private var systemDefaultEditor: Editor? {
    let defaultEditorCFURL = LSCopyDefaultApplicationURLForURL(sampleFileURL as CFURL, .Editor, nil)?.takeUnretainedValue()

    guard let systemDefaultEditorURL = defaultEditorCFURL as NSURL?,
      let systemDefaultEditorName: String = (try? systemDefaultEditorURL.resourceValuesForKeys([NSURLLocalizedNameKey])[NSURLLocalizedNameKey]) as? String
      else { return .None }

    return Editor(name: systemDefaultEditorName, path: systemDefaultEditorURL)
  }

  func registerDefaults() {
    guard let defaultEditor = systemDefaultEditor ?? editors.last else { return }
    defaults.registerDefaults(["defaultEditorPath": defaultEditor.path.absoluteString])
    defaults.registerDefaults(["defaultEditorName": defaultEditor.name])
  }
}
