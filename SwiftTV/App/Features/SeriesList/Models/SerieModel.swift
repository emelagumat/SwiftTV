
import Domain

struct SerieModel: Identifiable, Equatable {
    let id: String
    let name: String
    let overview: String
    let backdropStringURL: String
    let posterStringURL: String
    let genders: [SerieGenre]
    let rate: RateModel
}

extension SerieModel {
    init(_ media: MediaItem) {
        self.init(
            id: String(media.id),
            name: media.name,
            overview: media.overview,
            backdropStringURL: media.backdropURL,
            posterStringURL: media.posterURL,
            genders: media.genres.map(SerieGenre.init),
            rate: .init(media.rate)
        )
    }
}
