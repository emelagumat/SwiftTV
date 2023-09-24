
import Data
import Domain
import Foundation

class DataDIContainer {
    let tabBarRepository: TabBarRepository
    lazy private(set) var discoverRepository: DiscoverRepository = DiscoverRepositoryImpl(provider: provider)
    let provider: TMDBProvider
    
    init(
        provider: TMDBProvider = .init(authToken: ProcessInfo.processInfo.environment["AUTH_TOKEN"]!)
    ) {
        self.tabBarRepository = TabBarRepositoryImpl()
        self.provider = provider
    }
}
