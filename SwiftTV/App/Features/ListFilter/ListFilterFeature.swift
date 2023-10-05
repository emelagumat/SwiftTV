import ComposableArchitecture

struct ListFilterFeature: Reducer {
    var body: some ReducerOf<ListFilterFeature> {
        Reduce { state, action in
            switch action {
            case .onActivateButtonTapped:
                state.isActive.toggle()
                return .none
            case var .onSelect(item):
                item.isSelected.toggle()
                if let itemIndex = state.items.firstIndex(where: { $0.id == item.id }) {
                    state.items[itemIndex] = item
                }
                let filters = state.items.filter(\.isSelected)
                return .send(.onSetFilters(filters))
            case .onSetFilters:
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
        case onSetFilters([FilterItem])
    }
}
