
import ComposableArchitecture

struct ListFilterFeature: Reducer {
    var body: some ReducerOf<ListFilterFeature> {
        Reduce { state, action in
            switch action {
            case .onActivateButtonTapped:
                state.isActive.toggle()
                return .none
            case let .onSelect(item):
                return .none
            }
        }
    }
}

// MARK: - State
extension ListFilterFeature {
    struct State: FeatureState {
        var isActive = false
        var items: [FilterItem] = []
    }
}

// MARK: - State
extension ListFilterFeature {
    enum Action: Equatable {
        case onActivateButtonTapped
        case onSelect(FilterItem)
    }
}
