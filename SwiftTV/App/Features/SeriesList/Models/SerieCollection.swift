import SwiftUI
import Domain

struct SerieCollection: Identifiable, Equatable {
    let id: String
    let title: String
    let category: MediaCollection.Category.Serie
    let items: [SerieModel]
}

extension SerieCollection {
    init(mediaCollection: MediaCollection) {
        let serieCategory: MediaCollection.Category.Serie

        if case let .series(category) = mediaCollection.category {
            serieCategory = category
        } else {
            serieCategory = .popular
        }
        self.init(
            id: UUID().uuidString,
            title: mediaCollection.category.displayName,
            category: serieCategory,
            items: mediaCollection.items.map {
                SerieModel(
                    id: String($0.id),
                    name: $0.name,
                    overview: $0.overview,
                    backdropStringURL: $0.backdropURL,
                    posterStringURL: $0.posterURL,
                    genres: $0.genres.map { SerieGenre(id: $0.id, name: $0.name)},
                    rate: .init($0.rate)
                )
            }
        )
    }
}

extension MediaCollection.Category {
    var displayName: String {
        switch self {
        case let .series(series):
            series.displayName
        case let .movies(movies):
            movies.displayName
        }
    }
}

private extension MediaCollection.Category.Serie {
    var displayName: String {
        switch self {
        case .airingToday:
            "Airing today"
        case .onTheAir:
            "On the Air"
        case .popular:
            "Popular"
        case .topRated:
            "Top rated"
        }
    }
}
private extension MediaCollection.Category.Movie {
    var displayName: String {
        switch self {
        case .nowPlaying:
            "Now Playing"
        case .upcoming:
            "Upcoming"
        case .popular:
            "Popular"
        case .topRated:
            "Top rated"
        }
    }
}
