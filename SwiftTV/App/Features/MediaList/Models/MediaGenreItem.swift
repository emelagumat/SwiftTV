import Domain

struct MediaGenreItem: Identifiable, Equatable {
    let id: Int
    let name: String
}

extension MediaGenreItem {
    init(_ media: MediaGenre) {
        self.init(
            id: media.id,
            name: media.name
        )
    }
}
