import SwiftUI
import AppKit

struct BlurEffectView: NSViewRepresentable {
  var material: NSVisualEffectView.Material
  var blendingMode: NSVisualEffectView.BlendingMode

  func makeNSView(context: Context) -> NSVisualEffectView {
    let visualEffectView = NSVisualEffectView()
    visualEffectView.material = material
    visualEffectView.blendingMode = blendingMode
    visualEffectView.state = NSVisualEffectView.State.active

    return visualEffectView
  }

  func updateNSView(
    _ visualEffectView: NSVisualEffectView,
    context: Context
  ) {
    visualEffectView.material = material
    visualEffectView.blendingMode = blendingMode
  }

  init(
    material: NSVisualEffectView.Material = .appearanceBased,
    blendingMode: NSVisualEffectView.BlendingMode = .withinWindow
  ) {
    self.material = material
    self.blendingMode = blendingMode
  }
}
