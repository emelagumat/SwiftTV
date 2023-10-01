extension SeriesListView {
    enum Action: Equatable {
        case onAppear
        case onSelect(SerieModel)
    }
}

extension SeriesListView.Action {
    var featureAction: SeriesListFeature.Action {
        switch self {
        case .onAppear:
            .onAppear
        case let .onSelect(serieModel):
            .onSelect(serieModel)
        }
    }
}
