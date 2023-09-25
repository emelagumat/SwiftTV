
import SwiftUI
import Domain

struct SerieCollection: Identifiable, Equatable {
    let id: String
    let title: String
    let items: [SerieModel]
}

struct SerieModel: Identifiable, Equatable {
    let id: String
    let name: String
    let backdropStringURL: String
}

extension SerieCollection {
    init(mediaCollection: MediaCollection) {
        self.init(
            id: UUID().uuidString,
            title: mediaCollection.category.displayName,
            items: mediaCollection.items.map {
                SerieModel(
                    id: String($0.id),
                    name: $0.name,
                    backdropStringURL: $0.backdropURL
                )
            }
        )
    }
}

private extension MediaCollection.Category {
    var displayName: String {
        switch self {
        case let .series(series):
            series.displayName
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
