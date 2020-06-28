import SwiftUI
import ComposableArchitecture

struct MarkupRenderView: View {
  var store: Store<MarkupRender.State, MarkupRender.Action>
  @State var scrollPosition: Float = 0

  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack(alignment: .bottom) {
        WebView(html: viewStore.html, scrollPosition: $scrollPosition)

        HStack {
          Text(viewStore.metadata)
          Spacer()
          Button(action: {
            //
          }) {
            Image("OpenInEditor")
              .resizable()
              .frame(width: 16, height: 16)
          }
          .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(BlurView())
      }
    }
  }
}
