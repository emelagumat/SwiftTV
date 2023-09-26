
import Data
import Domain
import Foundation

class DataDIContainer {
    let tabBarRepository: TabBarRepository
    let provider: TMDBProvider
    
    lazy private(set) var discoverRepository: DiscoverRepository = DiscoverRepositoryImpl(provider: provider)
    lazy private(set) var listsRepository: ListsRepository = ListsRepositoryImpl(
        apiService: SeriesListApiService(),
        provider: provider
    )
    lazy private(set) var imageLoader = ImageLoader(provider: provider)
    
    init(
        provider: TMDBProvider = .init(authToken: ProcessInfo.processInfo.environment["AUTH_TOKEN"] ?? "")
    ) {
        self.tabBarRepository = TabBarRepositoryImpl()
        self.provider = provider
    }
}
