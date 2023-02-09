import ComposableArchitecture

public struct PinScreenFeature: ReducerProtocol {
    public struct State: Equatable {
        var currentInput: String = ""
        
        public init(currentInput: String = "") {
            self.currentInput = currentInput
        }
    }
    
    public enum Action: Equatable {
        case didTapDigit(Int)
        case didUnlock
        case didTapCorrect
    }
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
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
