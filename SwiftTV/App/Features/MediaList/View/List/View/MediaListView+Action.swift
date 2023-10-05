extension MediaListView {
    enum Action: Equatable {
        case onAppear
        case onSelect(MediaItemModel)
    }
}

extension MediaListView.Action {
    var featureAction: MediaListFeature.Action {
        switch self {
        case .onAppear:
            .onAppear
        case let .onSelect(serieModel):
            .onSelect(serieModel)
        }
    }
}
