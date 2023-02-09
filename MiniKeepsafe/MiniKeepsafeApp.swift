import ComposableArchitecture
import SwiftUI
import XCTestDynamicOverlay

struct MainApp: ReducerProtocol {
    
    struct State: Equatable {
        /// This holds the state for our gridViewer feature.
        var gridViewer: GridViewFeature.State = .init()
        
        /// This holds the optional pin screen feature state. The view will only be displayed when the state is set.
        var pinScreen: PinScreenFeature.State?
    }
    
    enum Action: Equatable {
        case appResumed
        case appBackgrounded
        case gridViewer(GridViewFeature.Action)
        case pinScreen(PinScreenFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.gridViewer, action: /Action.gridViewer) {
            GridViewFeature()
        }
        .ifLet(\.pinScreen, action: /Action.pinScreen) {
            PinScreenFeature()
        }
        Reduce { state, action in
            switch action {
            case .appResumed:
                state.pinScreen = .init()
                return .none
                
            case .appBackgrounded:
                state.pinScreen = .init()
                return .none
                
            case .gridViewer:
                return .none
                
            case .pinScreen(.didUnlock):
                state.pinScreen = nil
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
            if !_XCTIsTesting {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    ZStack {
                        GridViewFeature_View(
                            store: store.scope(
                                state: \.gridViewer,
                                action: MainApp.Action.gridViewer
                            )
                        )
                        
                        IfLetStore(
                            store.scope(
                                state: \.pinScreen,
                                action: MainApp.Action.pinScreen),
                            then: { scopedStore in
                                Color.white
                                    .edgesIgnoringSafeArea(.all)
                                    .overlay {
                                        PinScreenFeature_View(store: scopedStore)
                                    }
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
}
