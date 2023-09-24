
import Domain
import APIClient

public class DiscoverRepositoryImpl: DiscoverRepository {
    private let provider: TMDBProvider
    
    public init(provider: TMDBProvider) {
        self.provider = provider
    }
    
    public func getDiscovery() async {
        let endPoint = Endpoint(
            baseStringURL: "https://api.themoviedb.org/3",
            path: "/discover/movie",
            parameters: [:],
            method: .get,
            task: .queryParams,
            headers: [:]
        )
        do {
            let response = try await provider.getResponse(from: endPoint) as PaginatedResponse<MediaItemResponse>
            print(response.results?.count)
        } catch {
            print(error)
        }
    }
}

struct PaginatedResponse<T: Codable>: Codable {
    let page: Int?
    let results: [T?]?
}

struct MediaItemResponse: Codable {
    let id: Int?
    let original_title: String?
}
