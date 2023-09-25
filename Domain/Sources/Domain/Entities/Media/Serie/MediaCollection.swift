
import Foundation

public struct MediaCollection: Equatable {
    public let category: Category
    public private(set) var items: [MediaItem]
    public private(set) var hasMoreItems: Bool
    
    public init(
        category: MediaCollection.Category,
        items: [MediaItem],
        hasMoreItems: Bool
    ) {
        self.category = category
        self.items = items
        self.hasMoreItems = hasMoreItems
    }
    
    mutating public func addItems(_ items: [MediaItem], hasMore: Bool) {
        self.items.append(contentsOf: items)
        self.hasMoreItems = hasMore
    }
}

public extension MediaCollection {
    enum Category: Equatable, Hashable {
        case series(Serie)
    }
}

public extension MediaCollection.Category {
    enum Serie: Equatable, Hashable, CaseIterable {
        case airingToday
        case onTheAir
        case popular
        case topRated
    }
}
