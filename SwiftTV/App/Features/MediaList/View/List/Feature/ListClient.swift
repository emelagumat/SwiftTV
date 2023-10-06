import Domain
import ComposableArchitecture

struct ListClient {
    let getNextPage: (Int, MediaCollection.Category) async throws -> Result<MediaCollection, DomainError>
    let getAllGenres: () async -> Result<[MediaGenre], DomainError>
    var getNextDiscoveryPage: ((Int, DiscoveryRequest) async throws -> Result<[MediaCollection], DomainError>) = { _, _ in .success([]) }
}

extension ListClient {
    static let mock = ListClient(
        getNextPage: { _, _ in
            .failure(.unknown)
        },
        getAllGenres: {
            .failure(.unknown)
        }
    )
}

enum ListClientKey: DependencyKey {
    static let liveValue = ListClient(
        getNextPage: {
            await DomainDIContainer.shared.listUseCase.getPage($0, for: $1)
        },
        getAllGenres: {
            await DomainDIContainer.shared.listUseCase.getAllGenres()
        },
        getNextDiscoveryPage: {
            await DomainDIContainer.shared.listUseCase.getDiscoveryPage($0, for: $1)
        }
    )

    static let movies = ListClient(
        getNextPage: {
            await DomainDIContainer.shared.movieListUseCase.getPage($0, for: $1)
        },
        getAllGenres: {
            await DomainDIContainer.shared.movieListUseCase.getAllGenres()
        }
    )
}

extension DependencyValues {
    var listClient: ListClient {
        get { self[ListClientKey.self] }
        set { self[ListClientKey.self] = newValue }
    }
}
