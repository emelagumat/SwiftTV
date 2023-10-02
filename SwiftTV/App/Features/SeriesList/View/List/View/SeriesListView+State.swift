extension SeriesListView {
    struct State: Equatable {
        var genres: [FilterItem] = []
        var sections: [SerieCollection] = []
    }
}

extension SeriesListView.State {
    init(featureState: SeriesListFeature.State) {
        self.genres = featureState.genres
        self.sections = []
    }
}