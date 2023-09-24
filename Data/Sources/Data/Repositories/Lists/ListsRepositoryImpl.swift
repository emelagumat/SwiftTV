
import Domain

public final class ListsRepositoryImpl: ListsRepository {
    private let apiService: SeriesListApiService
    private let provider: TMDBProvider
    
    private var pagesDict: [MediaCollection.Category: Int] = [:]
    
    public init(apiService: SeriesListApiService, provider: TMDBProvider) {
        self.apiService = apiService
        self.provider = provider
    }
    
    public func getNextPage(for category: MediaCollection.Category) async -> Result<MediaCollection, DomainError> {
        let nextPage = pagesDict[category, default: 1]
        pagesDict[category] = nextPage + 1
        
        let endpoint = apiService.buildEndpoint(
            with: .getPage(page: nextPage, category: category)
        )
        
        do {
            let response: PaginatedResponse<SerieResponse> = try await provider.getResponse(from: endpoint)
            let results = (response.results ?? []).compactMap { $0 }.map {
                MediaItem(response: $0, category: .serie)
            }
            let collection = MediaCollection(
                category: category,
                items: results,
                hasMoreItems: (response.totalPages ?? .zero) < (pagesDict[category, default: 1] - 1)
            )
            
            return .success(collection)
        } catch {
            return .failure(.unknown)
        }
    }
}
