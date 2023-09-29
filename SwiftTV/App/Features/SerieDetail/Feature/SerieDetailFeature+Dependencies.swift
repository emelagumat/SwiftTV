
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
        backdropStringURL: "",
        posterStringURL: ""
    )
}

extension DependencyValues {
    var selectedSerie: SerieModel {
        get { self[SerieModel.Key.self] }
        set { self[SerieModel.Key.self] = newValue }
    }
}
