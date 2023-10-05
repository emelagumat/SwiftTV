import Domain

struct MediaItemModel: Identifiable, Equatable {
    let id: String
    let name: String
    let overview: String
    let backdropStringURL: String
    let posterStringURL: String
    let genres: [MediaGenreItem]
    let rate: RateModel
}

extension MediaItemModel {
    init(_ media: MediaItem) {
        let tvMedia = media as? TVMediaItem
        let movieMedia = media as? MovieMediaItem
        self.init(
            id: String(media.id),
            name: tvMedia?.name ?? movieMedia?.title ?? "",
            overview: tvMedia?.overview ?? movieMedia?.overview ?? "",
            backdropStringURL: media.backdropURL,
            posterStringURL: media.posterURL,
            genres: media.genres.map(MediaGenreItem.init),
            rate: .init(media.rate)
        )
    }
}
