import APIClient
import Domain

public final class GenresAPIService: TMDBApiService {
    public var path: String { "/genre" }

    public init() {}
}

public extension GenresAPIService {
    enum Action: APIServiceAction {
        case series

        public var subpath: String {
            switch self {
            case .series:
                "/tv/list"
            }
        }

        public var parameters: [String: Any] { [:] }
    }
}
