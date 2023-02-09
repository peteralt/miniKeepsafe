import ComposableArchitecture
import SnapshotTesting
import XCTest
@testable import MiniKeepsafe

final class PinScreenFeatureSnapshotTests: XCTestCase {
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
