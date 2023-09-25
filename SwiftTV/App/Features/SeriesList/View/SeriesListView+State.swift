
extension SeriesListView {
    struct State: Equatable {
        init() {}
    }
}

extension SeriesListView.State {
    init(featureState: SeriesListFeature.State) {
        self.init()
    }
}
