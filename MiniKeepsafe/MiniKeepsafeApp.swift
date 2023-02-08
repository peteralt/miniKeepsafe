import ComposableArchitecture
import SwiftUI

struct MainApp: ReducerProtocol {
    
    struct State: Equatable {
        var gridViewer: GridViewFeature.State = .init()
    }
    
    enum Action: Equatable {
        case appResumed
        case appBackgrounded
        case gridViewer(GridViewFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .appResumed:
                print("resumed")
                return .none
                
            case .appBackgrounded:
                print("backgrounded")
                return .none
                
            case .gridViewer:
                return .none
            }
        }
        Scope(state: \.gridViewer, action: /Action.gridViewer) {
            GridViewFeature()
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
            GridViewFeature_View(
                store: .init(
                    initialState: .sample,
                    reducer: GridViewFeature()
                )
            )
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
