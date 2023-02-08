import Foundation

struct RemoteImage: Equatable, Identifiable, Codable {
    var id: String
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "download_url"
    }
}

#if DEBUG
extension RemoteImage {
    /// Convenience initializer to set URL and ID to the URL(String) provided.
    init(string: String) {
        self.url = URL(string: string)!
        self.id = string
    }
}
#endif
