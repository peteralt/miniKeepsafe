import SwiftUI

@main
struct MiniKeepsafeApp: App {
    var body: some Scene {
        WindowGroup {
            GridViewFeature_View(
                store: .init(
                    initialState: .sample,
                    reducer: GridViewFeature()
                )
            )
        }
    }
}
