
public protocol TabBarUseCase {
    func getTabInfo() async -> Result<TabBarInfo, DomainError>
}

public final class TabBarUseCaseImpl: TabBarUseCase {
    private let tabBarRepository: TabBarRepository
    
    public init(tabBarRepository: TabBarRepository) {
        self.tabBarRepository = tabBarRepository
    }
    
    public func getTabInfo() async -> Result<TabBarInfo, DomainError> {
        await tabBarRepository.getTabInfo()
    }
}
