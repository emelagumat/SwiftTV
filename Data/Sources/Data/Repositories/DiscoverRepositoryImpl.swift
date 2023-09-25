
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
            let response = try await provider.getResponse(from: endPoint) as PaginatedResponse<SerieResponse>
        } catch {
            print(error)
        }
    }
}
