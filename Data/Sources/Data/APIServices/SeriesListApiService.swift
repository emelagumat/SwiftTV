
import APIClient
import Domain

public protocol TMDBApiService: APIService {}

public extension TMDBApiService {
    var baseStringURL: String {
        "https://api.themoviedb.org/3"
    }
}

public final class SeriesListApiService: TMDBApiService {
    public typealias Action = SeriesListApiServiceAction
    
    public var path: String { "/tv" }
    
}

public enum SeriesListApiServiceAction: APIServiceAction {
    case getPage(page: Int, category: MediaCollection.Category)
    
    public var subpath: String {
        switch self {
        case let .getPage(_, category):
            category.endpointPath
        }
    }
    
    public var parameters: [String : Any] {
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
        }
    }
}
