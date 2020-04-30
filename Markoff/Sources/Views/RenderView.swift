import SwiftUI

struct RenderView: View {
  var body: some View {
    Text("Hello, World!")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}


struct RenderView_Previews: PreviewProvider {
  static var previews: some View {
    RenderView()
  }
}
