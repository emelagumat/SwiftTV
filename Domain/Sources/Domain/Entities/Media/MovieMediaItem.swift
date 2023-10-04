import Foundation

public struct MovieMediaItem: MediaItem {
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

    public init(
        id: Int,
        releaseDate: Date? = nil,
        title: String,
        originalTitle: String,
        originCountryCode: [String],
        overview: String,
        backdropURL: String,
        posterURL: String,
        genres: [MediaGenre],
        rate: MediaItemRate,
        category: MediaItemCategory,
        isForAdults: Bool
    ) {
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

}
