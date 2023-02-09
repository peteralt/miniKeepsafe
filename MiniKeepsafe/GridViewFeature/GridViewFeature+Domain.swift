import ComposableArchitecture
import Foundation

struct GridViewFeature: ReducerProtocol {
    @Dependency(\.apiClient) var apiClient
    private enum APIRequestCancellationID {}
    
    struct State: Equatable {
        var images: IdentifiedArrayOf<RemoteImage> = []
        
        /// Displays a loading state indicator at the end of the list of images
        var isLoading: Bool = false
        
        /// Holds paging information
        var currentPage: Int = 1
        
        /// Constant to define how many images should be loaded per page.
        let imageLimit: Int = 10
        
        /// Optional state for the FullscreenViewerFeature
        var fullscreenState: FullscreenViewerFeature.State?
    }
    
    enum Action: Equatable {
        case didAppear
        case didReachEndOfList
        case images(TaskResult<[RemoteImage]>)
        case didSelectImage(RemoteImage)
        case fullscreenFeature(FullscreenViewerFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {

            case .didAppear:
                state.isLoading = true
                state.currentPage = 1
                return .task { [state] in
                    return await .images(TaskResult {
                        try await apiClient
                            .fetchImages(state.currentPage, state.imageLimit)
                    })
                }
                .cancellable(id: APIRequestCancellationID.self)
                
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
                return .none
                
            case let .images(.failure(error)):
                print(error.localizedDescription)
                return .none
                
            case let .didSelectImage(image):
                state.fullscreenState = .init(images: state.images, selectedImage: image)
                return .none
                
            case .images:
                return .none
                
            case .fullscreenFeature(.didTapBack):
                state.fullscreenState = nil
                return .none
                
            case .fullscreenFeature:
                return .none
            }
        }
        .ifLet(\.fullscreenState, action: /Action.fullscreenFeature) {
            FullscreenViewerFeature()
        }
    }
}
