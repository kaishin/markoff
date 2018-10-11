import Foundation

class PreferencesController {
  let defaults = UserDefaults.standard

  lazy var editors: [Editor] = {
    let editorURLArray = LSCopyApplicationURLsForURL(self.sampleFileURL as CFURL, LSRolesMask.editor)!.takeUnretainedValue() as NSArray
    let editorURLs = editorURLArray as? [URL] ?? []

    return editorURLs.map { URL in
      let applicationName: String = (try? (URL as NSURL).resourceValues(forKeys: [URLResourceKey.localizedNameKey])[URLResourceKey.localizedNameKey]) as? String ?? "Unknown Editor"
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
      defaults["defaultEditorPath"] = newValue.path.absoluteString as AnyObject
      defaults["defaultEditorName"] = newValue.name as AnyObject
    }
  }

  fileprivate lazy var sampleFileURL: URL = {
    return Bundle.main.url(forResource: "sample", withExtension: "md", subdirectory: "Template")!
  }()

  fileprivate var systemDefaultEditor: Editor? {
    let defaultEditorCFURL = LSCopyDefaultApplicationURLForURL(sampleFileURL as CFURL, .editor, nil)?.takeUnretainedValue()

    guard let systemDefaultEditorURL = defaultEditorCFURL as URL?,
      let systemDefaultEditorName: String = (try? (systemDefaultEditorURL as NSURL).resourceValues(forKeys: [URLResourceKey.localizedNameKey])[URLResourceKey.localizedNameKey]) as? String
      else { return .none }

    return Editor(name: systemDefaultEditorName, path: systemDefaultEditorURL)
  }

  func registerDefaults() {
    guard let defaultEditor = systemDefaultEditor ?? editors.last else { return }
    defaults.register(defaults: ["defaultEditorPath": defaultEditor.path.absoluteString])
    defaults.register(defaults: ["defaultEditorName": defaultEditor.name])
  }
}
