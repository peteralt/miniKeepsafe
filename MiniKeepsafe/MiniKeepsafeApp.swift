import ComposableArchitecture
import SwiftUI

struct MainApp: ReducerProtocol {
    
    struct State: Equatable {
        var gridViewer: GridViewFeature.State = .init()
        
        var pinScreen: PinScreenFeature.State?
        @BindingState var isPresentingPinScreen: Bool = true
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case appResumed
        case appBackgrounded
        case gridViewer(GridViewFeature.Action)
        case pinScreen(PinScreenFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
            .ifLet(\.pinScreen, action: /Action.pinScreen) {
                PinScreenFeature()
            }
        Scope(state: \.gridViewer, action: /Action.gridViewer) {
            GridViewFeature()
        }
        Reduce { state, action in
            switch action {
            case .appResumed:
                state.isPresentingPinScreen = true
                state.pinScreen = .init()
                return .none
                
            case .appBackgrounded:
                state.pinScreen = .init()
                state.isPresentingPinScreen = true
                return .none
                
            case .gridViewer:
                return .none
                
            case .binding:
                return .none
                
            case .pinScreen(.unlock):
                state.pinScreen = nil
                state.isPresentingPinScreen = false
                return .none
                
            case .pinScreen:
                return .none
            }
        }
    }
}

@main
struct MiniKeepsafeApp: App {
    let store: StoreOf<MainApp> = .init(
        initialState: .init(),
        reducer: MainApp()
    )
    
    @Environment(\.scenePhase)
    private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            WithViewStore(store, observe: { $0 }) { viewStore in
                GridViewFeature_View(
                    store: store.scope(
                        state: \.gridViewer,
                        action: MainApp.Action.gridViewer
                    )
                )
                .fullScreenCover(
                    isPresented: viewStore.binding(\.$isPresentingPinScreen)) {
                        IfLetStore(
                            store.scope(
                                state: \.pinScreen,
                                action: MainApp.Action.pinScreen),
                            then: {
                                PinScreenFeature_View(store: $0)
                            })
                    }
            }
            .onChange(of: scenePhase) { (newScenePhase) in
                let viewStore = ViewStore(store)
                switch (scenePhase, newScenePhase) {
                case (.inactive, .active):
                    viewStore.send(.appResumed)
                case (.active, .inactive):
                    viewStore.send(.appBackgrounded)
                default:
                    break
                }
            }
        }
    }
}
