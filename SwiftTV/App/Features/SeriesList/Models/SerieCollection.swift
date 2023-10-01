
import SwiftUI
import Domain

struct SerieCollection: Identifiable, Equatable {
    let id: String
    let title: String
    let category: MediaCollection.Category.Serie
    let items: [SerieModel]
    
    init(id: String, title: String, category: MediaCollection.Category.Serie, items: [SerieModel]) {
        self.id = id
        self.title = title
        self.category = category
        self.items = items
    }
}

struct SerieModel: Identifiable, Equatable {
    let id: String
    let name: String
    let overview: String
    let backdropStringURL: String
    let posterStringURL: String
    let genders: [SerieGender]
    let rate: RateModel
}

struct SerieGender: Identifiable, Equatable {
    let id: Int
    let name: String
}

struct RateModel: Equatable {
    let popularity: Double
    let voteAverage: Double
    let totalVotes: Int
}

extension RateModel {
    init(_ rate: MediaItem.Rate) {
        self.init(
            popularity: rate.popularity,
            voteAverage: rate.voteAverage,
            totalVotes: rate.totalVotes
        )
    }
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
                    genders: $0.genres.map { SerieGender(id: $0.id, name: $0.name)},
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
