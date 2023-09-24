
import Domain

class DomainDIContainer {
    let dataContainer: DataDIContainer
    
    lazy private(set) var tabBarUseCase: TabBarUseCase = TabBarUseCaseImpl(
        tabBarRepository: dataContainer.tabBarRepository
    )
    
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
