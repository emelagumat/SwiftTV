import ComposableArchitecture

protocol FeatureState: Equatable {
    init()
}

extension Store where State: FeatureState {
    convenience init<R: Reducer>(_ feature: R) where R.State == State, R.Action == Action {
        self.init(initialState: .init(), reducer: { feature })
    }
}
