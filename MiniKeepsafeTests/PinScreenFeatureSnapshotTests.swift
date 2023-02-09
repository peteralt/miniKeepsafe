import ComposableArchitecture
import SnapshotTesting
import XCTest
@testable import MiniKeepsafe

final class PinScreenFeatureSnapshotTests: XCTestCase {
    
    /*
     A simple example how snapshot tests can provide us some guidance around
     how a view is getting rendered. This is a very basic example, but it shows
     that the user input is getting obfuscated and the number of characters
     are properly displayed.
     */
    
    private let deviceImage: ViewImageConfig = .iPhone13

    func testEnteredPinRendersAsDots() throws {
        let store = Store(
            initialState: PinScreenFeature.State(currentInput: "123"),
            reducer: PinScreenFeature()
        )
        let view = PinScreenFeature_View(store: store)
        
        assertSnapshot(matching: view, as: .image(layout: .device(config: deviceImage)))
    }

}
