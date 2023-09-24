
import Domain

class DomainDIContainer {
    private let dataContainer: DataDIContainer
    
    lazy private(set) var tabBarUseCase: TabBarUseCase = TabBarUseCaseImpl(
        tabBarRepository: dataContainer.tabBarRepository
    )
    
    lazy private(set) var discoverUseCase: DiscoverUseCase = .init(discoverRepository: dataContainer.discoverRepository)
    
    init(
        dataContainer: DataDIContainer = .init()
    ) {
        self.dataContainer = dataContainer
    }
}

extension DomainDIContainer {
    static var mock: DomainDIContainer {
        .init()
    }
}
