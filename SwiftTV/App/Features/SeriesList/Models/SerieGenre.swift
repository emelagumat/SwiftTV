import Domain

struct SerieGenre: Identifiable, Equatable {
    let id: Int
    let name: String
}

extension SerieGenre {
    init(_ media: MediaGenre) {
        self.init(
            id: media.id,
            name: media.name
        )
    }
}
