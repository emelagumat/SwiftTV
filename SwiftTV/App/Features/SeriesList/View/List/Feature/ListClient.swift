import Domain
import ComposableArchitecture

struct ListClient {
    let getNextPage: (MediaCollection.Category) async throws -> Result<MediaCollection, DomainError>
    let getAllGenres: () async -> Result<[MediaGenre], DomainError>
}

extension ListClient {
    static let mock = ListClient(
        getNextPage: { _ in
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
            await DomainDIContainer.shared.listUseCase.getNextPage(for: $0)
        },
        getAllGenres: {
            await DomainDIContainer.shared.listUseCase.getAllGenres()
        }
    )

    static let movies = ListClient(
        getNextPage: {
            await DomainDIContainer.shared.movieListUseCase.getNextPage(for: $0)
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
