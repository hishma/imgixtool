import Foundation

public extension URLComponents {
    mutating func appendQueryItem(_ queryItem: URLQueryItem) {
        var items = self.queryItems ?? [URLQueryItem]()
        items.append(queryItem)
        self.queryItems = items
    }
}
