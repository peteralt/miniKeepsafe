import ComposableArchitecture
import Foundation
import Kingfisher
import SwiftUI

struct FullscreenViewer_View: View {
    let store: StoreOf<FullscreenViewerFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                TabView(selection: viewStore.binding(\.$selectedImage)) {
                    ForEach(viewStore.images) { image in
                        KFImage
                            .url(image.url)
                            .resizable()
                            .cacheOriginalImage()
                            .aspectRatio(contentMode: .fit)
                        .tag(image)
                    }
                }
                .background(Color.black)
                .toolbar() {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            viewStore.send(.didTapBack)
                        }
                    }
                }
            }
            .tabViewStyle(.page)
        }
    }
}

#if DEBUG
struct FullscreenViewer_View_Previews: PreviewProvider {
    static var previews: some View {
        FullscreenViewer_View(
            store: .init(
                initialState: .sample,
                reducer: FullscreenViewerFeature()
            )
        )
    }
}
#endif
