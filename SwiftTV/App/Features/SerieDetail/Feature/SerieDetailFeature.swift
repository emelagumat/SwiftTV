
import ComposableArchitecture

struct SerieDetailFeature: Reducer {
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}

// MARK: - State
extension SerieDetailFeature {
    struct State: FeatureState {
        var model: SerieModel
        
        init() {
            model = SerieModel.empty
        }
        
        init(model: SerieModel) {
            self.model = model
        }
    }
}

// MARK: - Action
extension SerieDetailFeature {
    enum Action: Equatable {
        case onAppear
    }
}
