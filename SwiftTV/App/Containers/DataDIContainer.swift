import Data
import Domain
import Foundation

class DataDIContainer {
    let tabBarRepository: TabBarRepository
    let provider: TMDBProvider

    lazy private(set) var listsRepository: ListsRepository = ListsRepositoryImpl(
        listApiService: SeriesListApiService(),
        discoveryApiService: .init(),
        genresApiService: GenresAPIService(),
        provider: provider
    )

    lazy private(set) var movieListsRepository: ListsRepository = ListsRepositoryImpl(
        listApiService: MoviesListApiService(),
        discoveryApiService: .init(),
        genresApiService: GenresAPIService(),
        provider: provider
    )

    lazy private(set) var movieListsRepository: ListsRepository = ListsRepositoryImpl(
        listApiService: MoviesListApiService(),
        genresApiService: GenresAPIService(),
        provider: provider
    )

    init(
        provider: TMDBProvider = .init(authToken: ProcessInfo.processInfo.environment["AUTH_TOKEN"] ?? "")
    ) {
        self.tabBarRepository = TabBarRepositoryImpl()
        self.provider = provider
    }
}
