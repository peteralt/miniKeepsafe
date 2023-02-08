import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

struct APIClient {
    var fetchImages: @Sendable (_ page: Int, _ limit: Int) async throws -> [RemoteImage]
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

extension APIClient: DependencyKey {
    static let liveValue = Self(
        fetchImages: { page, limit in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)")!)
            return try JSONDecoder().decode([RemoteImage].self, from: data)
        }
    )    
}
