import ComposableArchitecture

extension MediaItemModel {
    enum Key: DependencyKey {
        static var liveValue = MediaItemModel.empty
    }
}

extension MediaItemModel {
    static let empty = MediaItemModel(
        id: "",
        name: "",
        overview: "",
        backdropStringURL: "",
        posterStringURL: "",
        genres: [],
        rate: .init(images: [], totalVotes: .zero)
    )
}
