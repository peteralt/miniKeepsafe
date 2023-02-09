import ComposableArchitecture
import XCTest
@testable import MiniKeepsafe

final class MiniKeepsafeAppTests: XCTestCase {
    
    /*
     These are simple examples to showcase how simple it is to write
     unit tests with TCA. We're basically testing that sending an action
     into the store modifies our state as expected.
     */

    @MainActor
    func testAppLockedOnResumeAndUnlocks() async throws {
        let store = TestStore(initialState: MainApp.State(), reducer: MainApp())
        
        await store.send(.appResumed) {
            $0.pinScreen = .init()
        }
        
        await store.send(.pinScreen(.didUnlock)) {
            $0.pinScreen = nil
        }
    }
    
    @MainActor
    func testAppLockedOnBackgrounding() async throws {
        let state = MainApp.State()
        let store = TestStore(initialState: state, reducer: MainApp())
        
        XCTAssertEqual(state.pinScreen, nil)
        
        await store.send(.appBackgrounded) {
            $0.pinScreen = .init()
        }
    }
}
