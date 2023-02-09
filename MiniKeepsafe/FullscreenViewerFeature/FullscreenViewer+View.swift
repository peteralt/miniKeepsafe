import ComposableArchitecture
import Foundation
import SwiftUI

struct FullscreenViewer_View: View {
    let store: StoreOf<FullscreenViewerFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                TabView(selection: viewStore.binding(\.$selectedImage)) {
                    ForEach(viewStore.images) { image in
                        // I'm purposefully leaving AsyncImage in here for the time being
                        // just to show how this would work natively. As an interim step
                        // I would like to swap this out with the KingFisher library so
                        // we can make use of the caching provided by the library, but
                        // in the long term we want our own caching layer.
                        AsyncImage(url: image.url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
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
