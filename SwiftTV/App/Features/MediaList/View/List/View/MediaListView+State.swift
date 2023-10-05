extension MediaListView {
    struct State: Equatable {
        var genres: [FilterItem] = []
        var sections: [MediaItemCollection] = []
    }
}

extension MediaListView.State {
    init(featureState: MediaListFeature.State) {
        self.genres = featureState.genres
        self.sections = []
    }
}
