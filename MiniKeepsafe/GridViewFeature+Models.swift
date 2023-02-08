import Foundation

struct RemoteImage: Equatable, Identifiable {
    var id: String { url.absoluteString }
    var url: URL
    
    init(string: String) {
        self.url = URL(string: string)!
    }
}
