
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
        rate: .init(popularity: .zero, voteAverage: .zero, totalVotes: .zero)
    )
}

extension DependencyValues {
    var selectedSerie: SerieModel {
        get { self[SerieModel.Key.self] }
        set { self[SerieModel.Key.self] = newValue }
    }
}
