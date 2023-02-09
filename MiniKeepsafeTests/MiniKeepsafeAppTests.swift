import ComposableArchitecture
import XCTest
@testable import MiniKeepsafe

final class MiniKeepsafeAppTests: XCTestCase {

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
