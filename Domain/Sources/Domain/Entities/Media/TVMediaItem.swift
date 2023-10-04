import Foundation

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
