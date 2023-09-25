
extension SeriesListView {
    enum Action: Equatable {
        case onAppear
    }
}

extension SeriesListView.Action {
    var featureAction: SeriesListFeature.Action {
        switch self {
        case .onAppear:
            .onAppear
        }
    }
}
