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
            var jsonDecoder = JSONDecoder()
//            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)")!)
            return try jsonDecoder.decode([RemoteImage].self, from: data)
        }
    )
    
    /// This is the "unimplemented" fact dependency that is useful to plug into tests that you want
    /// to prove do not need the dependency.
    static let testValue = Self(
        fetchImages: unimplemented("\(Self.self).fetch")
    )
}
