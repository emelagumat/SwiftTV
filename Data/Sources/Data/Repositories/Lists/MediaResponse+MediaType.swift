import Domain
import Foundation

extension TVMediaItem {
    init?(response: MediaResponse?, category: MediaItemCategory, genres: [MediaGenre]) {
        guard let response else { return nil }
        self.init(
            id: response.id ?? .zero,
            firstAirDate: DateFormatter.tmdbApi.date(from: response.firstAirDate ?? ""),
            name: response.name ?? "",
            originCountryCode: (response.originCountry ?? []).compactMap { $0 },
            overview: response.overview ?? "",
            backdropURL: .temporalResourceBaseURL + (response.backdropPath ?? ""),
            posterURL: .temporalResourceBaseURL + (response.posterPath ?? ""),
            category: category,
            genres: (response.genreIDS ?? [])?.compactMap { genreID in genres.first(where: { $0.id == genreID}) } ?? [],
            rate: .init(
                popularity: response.popularity ?? .zero,
                voteAverage: response.voteAverage ?? .zero,
                totalVotes: response.voteCount ?? .zero
            )
        )
    }
}

extension MovieMediaItem {
    init?(response: MediaResponse?, category: MediaItemCategory, genres: [MediaGenre]) {
        guard let response else { return nil }
        self.init(
            id: response.id ?? .zero,
            releaseDate: DateFormatter.tmdbApi.date(from: response.firstAirDate ?? ""),
            title: response.title ?? "",
            originalTitle: response.originalTitle ?? "",
            originCountryCode: response.originCountry ?? [],
            overview: response.overview ?? "",
            backdropURL: .temporalResourceBaseURL + (response.backdropPath ?? ""),
            posterURL: .temporalResourceBaseURL + (response.posterPath ?? ""),
            genres: (response.genreIDS ?? [])?.compactMap { genreID in genres.first(where: { $0.id == genreID}) } ?? [],
            rate: .init(
                popularity: response.popularity ?? .zero,
                voteAverage: response.voteAverage ?? .zero,
                totalVotes: response.voteCount ?? .zero
            ),
            category: category,
            isForAdults: response.adult ?? false
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
