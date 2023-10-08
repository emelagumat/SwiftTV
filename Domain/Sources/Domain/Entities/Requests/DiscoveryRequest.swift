public struct DiscoveryRequest: Equatable, Hashable {
    public let category: MediaItemCategory
    public let genres: [MediaGenre]

    public init(category: MediaItemCategory, genres: [MediaGenre]) {
        self.category = category
        self.genres = genres
    }

    public func hash(into hasher: inout Hasher) {
        genres.map(\.id).forEach {
            hasher.combine($0)
        }
    }
}
