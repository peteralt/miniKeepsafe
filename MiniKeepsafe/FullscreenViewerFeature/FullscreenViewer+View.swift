import ComposableArchitecture
import Foundation
import SwiftUI

struct FullscreenViewerFeature: ReducerProtocol {
    
    struct State: Equatable {
        var images: IdentifiedArrayOf<RemoteImage> = []
        @BindingState var selectedImage: RemoteImage
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case didTapBack
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .didTapBack:
                return .none
            }
        }
    }    
}


struct FullscreenViewer_View: View {
    let store: StoreOf<FullscreenViewerFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                TabView(selection: viewStore.binding(\.$selectedImage)) {
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
                        .tag(image)
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
