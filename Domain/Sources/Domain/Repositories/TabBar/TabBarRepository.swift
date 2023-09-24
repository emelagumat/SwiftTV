
public protocol TabBarRepository {
    func getTabInfo() async -> Result<TabBarInfo, DomainError>
}
