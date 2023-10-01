import ComposableArchitecture

extension SerieModel {
    enum Key: DependencyKey {
        static var liveValue = SerieModel.empty
    }
}

extension SerieModel {
    static let empty = SerieModel(
        id: "",
        name: "",
        overview: "",
        backdropStringURL: "",
        posterStringURL: "",
        genders: [],
        rate: .init(images: [], totalVotes: .zero)
    )
}
