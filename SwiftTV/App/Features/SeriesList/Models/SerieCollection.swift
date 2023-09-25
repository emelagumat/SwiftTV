
import SwiftUI

struct SerieCollection: Identifiable {
    let id: String
    let items: [SerieModel]
}

struct SerieModel: Identifiable {
    let id: String
    let name: String
    let backdropStringURL: String
}
