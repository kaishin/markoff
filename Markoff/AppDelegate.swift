import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    PreferencesController().registerDefaults()
  }
}
