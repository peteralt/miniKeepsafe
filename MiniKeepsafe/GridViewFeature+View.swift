import ComposableArchitecture
import SwiftUI


struct GridViewFeature: ReducerProtocol {
    @Dependency(\.apiClient) var apiClient
    private enum APIRequestCancellationID {}
    
    struct State: Equatable {
        var images: IdentifiedArrayOf<RemoteImage> = []
        var isLoading: Bool = false
        var currentPage: Int = 1
        let imageLimit: Int = 10
    }
    
    enum Action: Equatable {
        case didReachEndOfList
        case images(TaskResult<[RemoteImage]>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didReachEndOfList:
            state.isLoading = true
            return .task { [state] in
                return await .images(TaskResult {
                    try await apiClient
                        .fetchImages(state.currentPage + 1, state.imageLimit)
                })
            }
            .cancellable(id: APIRequestCancellationID.self)
            
        case let .images(.success(images)):
            state.images.append(contentsOf: images)
            state.currentPage += 1
            state.isLoading = false
            print("count: \(state.images.count)")
            return .none
            
        case let .images(.failure(error)):
            print(error.localizedDescription)
            return .none
            
        case .images:
            return .none
        }
    }
}

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
                if viewStore.isLoading {
                    ProgressView()
                }
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
