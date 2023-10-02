import Domain

public final class TabBarRepositoryImpl: TabBarRepository {

    public init() {}

    public func getTabInfo() async -> Result<Domain.TabBarInfo, Domain.DomainError> {
        .success(
            TabBarInfo(
                defaultTab: TabItem.series.buildTab(),
                items: TabItem.allCases.map { $0.buildTab() }
            )
        )
    }
}

private enum TabItem: CaseIterable {
    case series
    case dashboard
    case two

    var title: String {
        switch self {
        case .series:
            "TV"
        case .dashboard:
            "Movies"
        case .two:
            "App"
        }
    }

    var symbolName: String {
        switch self {
        case .series:
            "play.tv"
        case .dashboard:
            "film.stack"
        case .two:
            "cross.fill"
        }
    }

    func buildTab() -> ApplicationTab {
        .init(
            id: "\(self)",
            name: title,
            symbolName: symbolName
        )
    }
}
