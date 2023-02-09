import ComposableArchitecture
import Kingfisher
import SwiftUI


struct GridViewFeature_View: View {
    let store: StoreOf<GridViewFeature>
    
    private let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    private let processor = DownsamplingImageProcessor(size: .init(width: 200, height: 200))
    |> ResizingImageProcessor(referenceSize: .init(width: 150, height: 150), mode: .aspectFill)
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(viewStore.images) { image in
                            Button(action: {
                                viewStore.send(.didSelectImage(image))
                            }) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.clear)
                                    .aspectRatio(contentMode: .fill)
                                    .overlay {
                                        // Using KFImage here because the default `AsyncImage` provided by SwiftUI
                                        // isn't overly performant. In a later cycle
                                        // we would probably want to control this more.
                                        KFImage
                                            .url(image.url)
                                            .setProcessor(processor)
                                            .cacheOriginalImage()
                                    }
                                    .onAppear {
                                        if viewStore.images.last == image {
                                            viewStore.send(.didReachEndOfList)
                                        }
                                    }
                            }
                            .clipped()
                        }
                    }
                    if viewStore.isLoading {
                        ProgressView()
                    }
                }
                
                IfLetStore(
                    store.scope(
                        state: \.fullscreenState,
                        action: GridViewFeature.Action.fullscreenFeature),
                    then: {
                        FullscreenViewer_View(store: $0)
                    })
            }
            .onAppear {
                viewStore.send(.didAppear)
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
