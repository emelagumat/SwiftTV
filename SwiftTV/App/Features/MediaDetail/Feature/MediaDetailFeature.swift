import ComposableArchitecture

struct MediaDetailFeature: Reducer {
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { _, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}

// MARK: - State
extension MediaDetailFeature {
    struct State: FeatureState {
        var model: MediaItemModel

        init() {
            model = MediaItemModel.empty
        }

        init(model: MediaItemModel) {
            self.model = model
        }
    }
}

// MARK: - Action
extension MediaDetailFeature {
    enum Action: Equatable {
        case onAppear
    }
}
