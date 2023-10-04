import SwiftUI
import Domain

struct SerieCollection: Identifiable, Equatable {
    let id: String
    let title: String
    let category: MediaCollection.Category
    let items: [SerieModel]
}

extension SerieCollection {
    init(mediaCollection: MediaCollection) {
        let serieCategory: MediaCollection.Category

        if case let .series(category) = mediaCollection.category {
            serieCategory = .series(category)
        } else if case let .movies(category) = mediaCollection.category {
            serieCategory = .movies(category)
        } else {
            serieCategory = .series(.popular)
        }
        self.init(
            id: UUID().uuidString,
            title: mediaCollection.category.displayName,
            category: serieCategory,
            items: mediaCollection.items.map {
                let tvMedia = $0 as? TVMediaItem
                return SerieModel(
                    id: String($0.id),
                    name: tvMedia?.name ?? "",
                    overview: tvMedia?.overview ?? "",
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
