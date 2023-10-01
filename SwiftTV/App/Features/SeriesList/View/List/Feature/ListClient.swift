
import Domain
import ComposableArchitecture

struct ListClient {
    let getNextPage: () async throws -> Result<MediaCollection, DomainError>
    let getAllGenres: () async -> Result<[MediaGender], DomainError>
}

extension ListClient {
    static let mock = ListClient(
        getNextPage: {
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
            .failure(.unknown)
        },
        getAllGenres: {
            .failure(.unknown)
        }
    )
}


extension DependencyValues {
    var listClient: ListClient {
        get { self[ListClientKey.self] }
        set { self[ListClientKey.self] = newValue }
    }
}
