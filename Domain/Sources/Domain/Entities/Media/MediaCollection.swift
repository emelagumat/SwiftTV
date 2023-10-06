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

    public static func == (lhs: MediaCollection, rhs: MediaCollection) -> Bool {
        lhs.category == rhs.category &&
        lhs.items.map(\.id) == rhs.items.map(\.id)
    }
}

public extension MediaCollection {
    enum Category: Equatable, Hashable {
        case series(Serie)
        case movies(Movie)
    }
}

public extension MediaCollection.Category {
    enum Serie: Equatable, Hashable, CaseIterable {
        case popular
        case airingToday
        case topRated
        case onTheAir
        case custom(String)
        
        public static var allCases: [MediaCollection.Category.Serie] {
            [
                .popular,
                .airingToday,
                .topRated,
                .onTheAir
            ]
        }
    }

    enum Movie: Equatable, Hashable, CaseIterable {
        case popular
        case upcoming
        case topRated
        case nowPlaying
        case custom(String)
        
        public static var allCases: [MediaCollection.Category.Movie] {
            [
                .popular,
                .upcoming,
                .topRated,
                .nowPlaying
            ]
        }
    }
}
