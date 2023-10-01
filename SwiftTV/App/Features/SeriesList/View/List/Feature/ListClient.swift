
import Domain
import ComposableArchitecture

struct ListClient {
    let getNextPage: () async throws -> Result<MediaCollection, DomainError>
}

extension ListClient {
    static let mock = ListClient(
        getNextPage: {
            .failure(.unknown)
        }
    )
}

enum ListClientKey: DependencyKey {
    static let liveValue = ListClient(
        getNextPage: {
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
