import ComposableArchitecture

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
