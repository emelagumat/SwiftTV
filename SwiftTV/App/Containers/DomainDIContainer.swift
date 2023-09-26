
import Domain
import Data

class DomainDIContainer {
    static let shared = DomainDIContainer()
    
    private let dataContainer: DataDIContainer
    
    lazy private(set) var tabBarUseCase: TabBarUseCase = TabBarUseCaseImpl(
        tabBarRepository: dataContainer.tabBarRepository
    )
    
    lazy private(set) var discoverUseCase: DiscoverUseCase = .init(discoverRepository: dataContainer.discoverRepository)
    lazy private(set) var listUseCase: ListsUseCase = .init(listsRepository: dataContainer.listsRepository)
    private init(
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
