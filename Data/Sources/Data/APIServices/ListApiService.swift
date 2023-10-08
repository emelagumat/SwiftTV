import Domain
import APIClient

public class ListApiService: TMDBApiService {
    public typealias Action = ListApiServiceAction

    public var path: String

    public init(path: String) {
        self.path = path
    }
}

public enum ListApiServiceAction: APIServiceAction {
    case getPage(page: Int, category: MediaCollection.Category)

    public var subpath: String {
        switch self {
        case let .getPage(_, category):
            category.endpointPath
        }
    }

    public var parameters: [String: Any] {
        var params: [String: Any] = [:]

        switch self {
        case let .getPage(page, _):
            params["page"] = page
        }

        return params
    }
}

private extension MediaCollection.Category {
    var endpointPath: String {
        switch self {
        case let .series(seriesCategory):
            seriesCategory.endpointPath

        case let .movies(moviesCategory):
            moviesCategory.endpointPath
        }
    }
}

private extension MediaCollection.Category.Serie {
    var endpointPath: String {
        switch self {
        case .airingToday:
            "/airing_today"
        case .onTheAir:
            "/on_the_air"
        case .popular:
            "/popular"
        case .topRated:
            "/top_rated"
        case .custom:
            ""
        }
    }
}

private extension MediaCollection.Category.Movie {
    var endpointPath: String {
        switch self {
        case .popular:
            "/popular"
        case .upcoming:
            "/upcoming"
        case .topRated:
            "/top_rated"
        case .nowPlaying:
            "/now_playing"
        case .custom:
            ""
        }
    }
}
