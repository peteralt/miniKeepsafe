import ComposableArchitecture
import SwiftUI


struct GridViewFeature_View: View {
    let store: StoreOf<GridViewFeature>
    
    private let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(viewStore.images) { image in
                        Button(action: {
                            viewStore.send(.didSelectImage(image))
                        }) {
                            AsyncImage(url: image.url) { phase in
                                switch phase {
                                case .empty:
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.purple)
                                        .border(Color.orange)
                                        .aspectRatio(contentMode: .fill)
                                case .success(let image):
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.green)
                                        .border(Color.orange)
                                        .aspectRatio(contentMode: .fill)
                                    //                                    .frame(maxWidth: 100, maxHeight: 100)
                                    //                                image
                                    //                                    .resizable()
                                    //                                    .aspectRatio(contentMode: .fill)
                                    //                                    .padding(1)
                                    //                                    .frame(maxWidth: 100, maxHeight: 100)
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    // Since the AsyncImagePhase enum isn't frozen,
                                    // we need to add this currently unused fallback
                                    // to handle any new cases that might be added
                                    // in the future:
                                    EmptyView()
                                }
                            }
                            .aspectRatio(contentMode: .fill)
                            //                        .frame(minWidth: 100, minHeight: 100)
                            .background(Color.red)
                            .onAppear {
                                if viewStore.images.last == image {
                                    viewStore.send(.didReachEndOfList)
                                }
                            }
                        }
                    }
                }
                if viewStore.isLoading {
                    ProgressView()
                }
            }
            .fullScreenCover(
                isPresented: viewStore.binding(\.$isFullscreenViewerPresented)) {
                IfLetStore(
                    store.scope(
                        state: \.fullscreenState,
                        action: GridViewFeature.Action.fullscreenFeature),
                    then: {
                        FullscreenViewer_View(store: $0)
                })
            }
        }
    }
}

#if DEBUG
struct GridViewFeature_View_Previews: PreviewProvider {
    static var previews: some View {
        GridViewFeature_View(
            store: .init(
                initialState: .sample,
                reducer: GridViewFeature()
            )
        )
    }
}
#endif
