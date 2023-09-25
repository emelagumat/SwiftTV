
extension SeriesListView {
    struct State: Equatable {
        var sections: [SerieCollection] = []
        
        init() {}
    }
}

extension SeriesListView.State {
    init(featureState: SeriesListFeature.State) {
        self.sections = []
    }
}
