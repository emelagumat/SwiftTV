
import ComposableArchitecture

struct SerieDetailFeature: Reducer {
    @Dependency(\.selectedSerie) var selectedSerie
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                state.model = selectedSerie
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
            model = SerieModel(
                id: "id",
                name: "name",
                backdropStringURL: "",
                posterStringURL: ""
            )
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
