import ComposableArchitecture
import Foundation
import SwiftUI

struct FullscreenViewerFeature: ReducerProtocol {
    
    struct State: Equatable {
        var images: IdentifiedArrayOf<RemoteImage> = []
    }
    
    enum Action: Equatable {
        case didTapBack
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapBack:
            return .none
        }
    }
}


struct FullscreenViewer_View: View {
    let store: StoreOf<FullscreenViewerFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                TabView {
                    ForEach(viewStore.images) { image in
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
                    }
                }
                .background(Color.black)
                .toolbar() {
                    ToolbarItem(placement: .navigation) {
                        Button("Back") {
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
