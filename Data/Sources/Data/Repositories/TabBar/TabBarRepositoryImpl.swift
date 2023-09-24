
import Domain

public final class TabBarRepositoryImpl: TabBarRepository {
    
    public init() {}
    
    public func getTabInfo() async -> Result<Domain.TabBarInfo, Domain.DomainError> {
        .success(
            TabBarInfo(
                defaultTab: TabItem.dashboard.buildTab(),
                items: TabItem.allCases.map { $0.buildTab() }
            )
        )
    }
}

private enum TabItem: CaseIterable {
    case one
    case dashboard
    case two
    
    var title: String {
        switch self {
        case .one:
            "One"
        case .dashboard:
            "Dashboard"
        case .two:
            "Two"
        }
    }
    
    var symbolName: String {
        switch self {
        case .one:
            "1.circle"
        case .dashboard:
            "house"
        case .two:
            "2.circle"
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
