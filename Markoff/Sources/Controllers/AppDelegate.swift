import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    PreferencesController().registerDefaults()
  }

  @IBAction func contactSupport(_ sender: AnyObject) {
    SupportController().contactSupport()
  }
}
