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
        
        /// Handles full screen overlay display
        @BindingState var isFullscreenViewerPresented: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case didReachEndOfList
        case images(TaskResult<[RemoteImage]>)
        case didSelectImage(RemoteImage)
        case fullscreenFeature(FullscreenViewerFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
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
                state.isFullscreenViewerPresented = true
                state.fullscreenState = .init(images: state.images, selectedImage: image)
                return .none
                
            case .images:
                return .none
                
            case .fullscreenFeature(.didTapBack):
                state.fullscreenState = nil
                state.isFullscreenViewerPresented = false
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
