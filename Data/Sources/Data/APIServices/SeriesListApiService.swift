import APIClient
import Domain

public final class SeriesListApiService: ListApiService {
    public init() {
        super.init(path: "/tv")
    }
}
public final class MoviesListApiService: ListApiService {
    public init() {
        super.init(path: "/movie")
    }
}
public class ListApiService: TMDBApiService {
    public typealias Action = SeriesListApiServiceAction

    public var path: String

    public init(path: String) {
        self.path = path
    }
}

public enum SeriesListApiServiceAction: APIServiceAction {
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
            switch seriesCategory {
            case .airingToday:
                "/airing_today"
            case .onTheAir:
                "/on_the_air"
            case .popular:
                "/popular"
            case .topRated:
                "/top_rated"
            }
        case let .movies(moviesCategory):
            switch moviesCategory {
            case .popular:
                "/popular"
            case .upcoming:
                "/upcoming"
            case .topRated:
                "/top_rated"
            case .nowPlaying:
                "/now_playing"
            }
        }
    
    }
}
