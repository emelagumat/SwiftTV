
import ComposableArchitecture

struct SeriesListFeature: Reducer {
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            .none
        }
    }
}

extension SeriesListFeature {
    struct State: Equatable {
        init() {
            
        }
    }
    
    enum Action: Equatable {
        case onAppear
    }
}
