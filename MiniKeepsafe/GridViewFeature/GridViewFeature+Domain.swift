import ComposableArchitecture
import Foundation

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
