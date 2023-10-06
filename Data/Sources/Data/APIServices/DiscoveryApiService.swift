
import Domain
import APIClient

public class DiscoveryApiService: TMDBApiService {
    public typealias Action = DiscoveryApiServiceAction
    
    public var path: String { "/discover" }
    
    public init() {}
}

public enum DiscoveryApiServiceAction: APIServiceAction {
    case getPage(page: Int, request: DiscoveryRequest)
    
    
    public var subpath: String {
        switch self {
        case let .getPage(_, request):
            switch request.category {
            case .tv:
                "/tv"
            case .movie:
                "/movie"
            }
        }
    }
    
    public var parameters: [String: Any] {
        var params: [String: Any] = [:]

        switch self {
        case let .getPage(page, request):
            params["page"] = page
            
            if !request.genres.isEmpty {
                params["with_genres"] = request.genres.map(\.id).map { String($0) }.joined(separator: ",")
                params["sort_by"] = "popularity.desc"
            }
        }

        return params
    }
}

/*
 https://api.themoviedb.org/3/discover/movie
 */
