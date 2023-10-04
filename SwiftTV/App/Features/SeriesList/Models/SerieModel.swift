import Domain

struct SerieModel: Identifiable, Equatable {

    let id: String
    let name: String
    let overview: String
    let backdropStringURL: String
    let posterStringURL: String
    let genres: [SerieGenre]
    let rate: RateModel
}

extension SerieModel {
    init(_ media: MediaItem) {
        let tvMedia = media as? TVMediaItem
        let movieMedia = media as? MovieMediaItem
        self.init(
            id: String(media.id),
            name: tvMedia?.name ?? movieMedia?.title ?? "",
            overview: tvMedia?.overview ?? movieMedia?.overview ?? "",
            backdropStringURL: media.backdropURL,
            posterStringURL: media.posterURL,
            genres: media.genres.map(SerieGenre.init),
            rate: .init(media.rate)
        )
    }
}
