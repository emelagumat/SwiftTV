import Foundation

public struct MediaGenre: Equatable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct MediaItem: Equatable {
    public let id: Int
    public let category: Category
    public let firstAirDate: Date?
    public let genres: [MediaGenre]
    public let name: String
    public let originCountryCode: [String]
    public let overview: String
    public let backdropURL: String
    public let posterURL: String
    public let rate: Rate

    public init(
        id: Int,
        category: MediaItem.Category,
        firstAirDate: Date? = nil,
        genres: [MediaGenre],
        name: String,
        originCountryCode: [String],
        overview: String,
        backdropURL: String,
        posterURL: String,
        rate: MediaItem.Rate
    ) {
        self.id = id
        self.category = category
        self.firstAirDate = firstAirDate
        self.genres = genres
        self.name = name
        self.originCountryCode = originCountryCode
        self.overview = overview
        self.backdropURL = backdropURL
        self.posterURL = posterURL
        self.rate = rate
    }
}

// MARK: - Rate
public extension MediaItem {
    struct Rate: Equatable {
        public let popularity: Double
        public let voteAverage: Double
        public let totalVotes: Int

        public init(
            popularity: Double,
            voteAverage: Double,
            totalVotes: Int
        ) {
            self.popularity = popularity
            self.voteAverage = voteAverage
            self.totalVotes = totalVotes
        }
    }
}

// MARK: - Category
public extension MediaItem {
    enum Category: Equatable {
        case serie
    }
}
