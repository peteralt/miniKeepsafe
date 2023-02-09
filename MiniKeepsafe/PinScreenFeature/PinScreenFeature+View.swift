import ComposableArchitecture
import SwiftUI


struct PinScreenFeature_View: View {
    let store: StoreOf<PinScreenFeature>
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                
                HStack {
                    ForEach(Array(viewStore.currentInput), id: \.self) { _ in
                        Circle()
                            .frame(width: 15)
                    }
                }
                
                Spacer()
                
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(1...9, id: \.self) { digit in
                        Button("\(digit)") {
                            viewStore.send(.didTapDigit(digit))
                        }
                        .padding()
                    }
                    
                }
                
                LazyVGrid(columns: columns, alignment: .center) {
                    // In order to set the grid up properly, we need a hidden
                    // button to balance it out.
                    Button("0"){}.padding().hidden()
                    
                    Button("0") {
                        viewStore.send(.didTapDigit(0))
                    }
                    .padding()
                    
                    Button(action: {
                        viewStore.send(.didTapCorrect)
                    }) {
                        Image(systemName: "delete.left.fill")
                    }
                    .padding()
                }
            }
        }
    }
}

#if DEBUG
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
#endif
