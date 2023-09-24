
import Foundation

public struct MediaCollection: Equatable {
    public let category: Category
    public let items: [MediaItem]
    public let hasMoreItems: Bool
}

public extension MediaCollection {
    enum Category: Equatable {
        case series(Serie)
    }
}

public extension MediaCollection.Category {
    enum Serie: Equatable {
        case airingToday
        case onTheAir
        case popular
        case topRated
    }
}
