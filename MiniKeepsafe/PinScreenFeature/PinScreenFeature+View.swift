import ComposableArchitecture
import SwiftUI

struct PinScreenFeature: ReducerProtocol {
    struct State: Equatable {
    }
    
    enum Action: Equatable {
        case unlock
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}

struct PinScreenFeature_View: View {
    let store: StoreOf<PinScreenFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Button(action: { viewStore.send(.unlock) }) {
                Text("unlock")
            }
        }
    }
}

struct PinScreenFeature_View_Previews: PreviewProvider {
    static var previews: some View {
        PinScreenFeature_View(
            store: .init(
                initialState: .init(),
                reducer: PinScreenFeature()
            )
        )
    }
}
