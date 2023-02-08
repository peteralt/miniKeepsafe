import ComposableArchitecture

struct PinScreenFeature: ReducerProtocol {
    struct State: Equatable {
        var currentInput: String = ""
    }
    
    enum Action: Equatable {
        case didTapDigit(Int)
        case didUnlock
        case didTapCorrect
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .didTapDigit(digit):
                state.currentInput += digit.description
                if state.currentInput == "123" {
                    return .init(value: .didUnlock)
                } else {
                    return .none
                }
                
            case .didUnlock:
                return .none
                
            case .didTapCorrect:
                state.currentInput = String(state.currentInput.dropLast())
                return .none
            }
        }
    }
}
