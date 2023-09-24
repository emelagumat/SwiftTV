
import Data
import Domain

class DataDIContainer {
    var tabBarRepository: TabBarRepository
    
    init(
        tabBarRepository: TabBarRepository = TabBarRepositoryImpl()
    ) {
        self.tabBarRepository = tabBarRepository
    }
}
