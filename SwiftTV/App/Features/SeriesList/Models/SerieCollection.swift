
import SwiftUI
import Domain

struct SerieCollection: Identifiable, Equatable {
    let id: String
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
