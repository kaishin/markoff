import AppKit

class PreferencesView: NSViewController {
  var preferences = PreferencesController()

  var defaultEditor: Editor {
    get {
      return preferences.defaultEditor
    }

    set {
      preferences.defaultEditor = newValue
    }
  }

  var editors: [Editor] {
    return preferences.editors
  }
}
