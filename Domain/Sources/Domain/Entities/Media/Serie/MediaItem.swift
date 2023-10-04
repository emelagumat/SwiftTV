import Foundation

public protocol MediaItem {
    var id: Int { get }
    var backdropURL: String { get }
    var posterURL: String { get }
    var category: MediaItemCategory { get }
    var genres: [MediaGenre] { get }
    var rate: MediaItemRate { get }
}

public struct TVMediaItem: MediaItem {
    public let id: Int
    public let firstAirDate: Date?
    public let name: String
    public let originCountryCode: [String]
    public let overview: String
    public let backdropURL: String
    public let posterURL: String
    public let category: MediaItemCategory
    public let genres: [MediaGenre]
    public let rate: MediaItemRate
    
    public init(id: Int, firstAirDate: Date? = nil, name: String, originCountryCode: [String], overview: String, backdropURL: String, posterURL: String, category: MediaItemCategory, genres: [MediaGenre], rate: MediaItemRate) {
        self.id = id
        self.firstAirDate = firstAirDate
        self.name = name
        self.originCountryCode = originCountryCode
        self.overview = overview
        self.backdropURL = backdropURL
        self.posterURL = posterURL
        self.category = category
        self.genres = genres
        self.rate = rate
    }
    
}


public struct MovieMediaItem: MediaItem {
    public init(id: Int, releaseDate: Date? = nil, title: String, originalTitle: String, originCountryCode: [String], overview: String, backdropURL: String, posterURL: String, genres: [MediaGenre], rate: MediaItemRate, category: MediaItemCategory, isForAdults: Bool) {
        self.id = id
        self.releaseDate = releaseDate
        self.title = title
        self.originalTitle = originalTitle
        self.originCountryCode = originCountryCode
        self.overview = overview
        self.backdropURL = backdropURL
        self.posterURL = posterURL
        self.genres = genres
        self.rate = rate
        self.category = category
        self.isForAdults = isForAdults
    }
    
    public let id: Int
    public let releaseDate: Date?
    public let title: String
    public let originalTitle: String
    public let originCountryCode: [String]
    public let overview: String
    public let backdropURL: String
    public let posterURL: String
    public let genres: [MediaGenre]
    public let rate: MediaItemRate
    public let category: MediaItemCategory
    public let isForAdults: Bool
}

public struct MediaItemRate: Equatable {
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

public enum MediaItemCategory: Equatable {
    case tv
    case movie
}
