import Domain

extension AppFeature {
    struct State: Equatable {
        var hasLaunched = false
        var tabBar: TabBarFeature.State?
    }
}

extension AppFeature.State {
    mutating func updateWithResult<T, U>(
        _ result: Result<T, DomainError>,
        mapper: (T) -> U,
        keyPath: KeyPath<Self, U>
    ) {
        switch result {
        case let .success(info as TabBarInfo):
            tabBar = .init(
                selectedTab: AppTabRepresentable(info.defaultTab),
                tabs: info.items.map { AppTabRepresentable($0) }
            )
        case .failure:
            break
        default:
            break
        }
    }
}
