
import Domain
import Foundation

extension MediaItem {
    init?(response: SerieResponse?, category: Category, genders: [MediaGenre]) {
        guard let response else { return nil }
        let g = (response.genreIDS ?? [])?.compactMap { genreID in genders.first(where: { $0.id == genreID}) } ?? []
        self.init(
            id: response.id ?? .zero,
            category: category,
            firstAirDate: DateFormatter.tmdbApi.date(from: response.firstAirDate ?? ""),
            genres: (response.genreIDS ?? [])?.compactMap { genreID in genders.first(where: { $0.id == genreID}) } ?? [],
            name: response.name ?? "",
            originCountryCode: (response.originCountry ?? []).compactMap { $0 },
            overview: response.overview ?? "",
            backdropURL: .temporalResourceBaseURL + (response.backdropPath ?? ""),
            posterURL: .temporalResourceBaseURL + (response.posterPath ?? ""),
            rate: .init(
                popularity: response.popularity ?? .zero,
                voteAverage: response.voteAverage ?? .zero,
                totalVotes: response.voteCount ?? .zero
            )
        )
    }
}

extension DateFormatter {
    static let tmdbApi: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "YYYY-mm-dd"
        return formatter
    }()
}

extension String {
    static let temporalResourceBaseURL: String = {
        "https://image.tmdb.org/t/p/w500"
    }()
}
