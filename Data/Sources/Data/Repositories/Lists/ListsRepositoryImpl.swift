
import Domain

public actor ListsRepositoryImpl: ListsRepository {
    private let apiService: SeriesListApiService
    private let provider: TMDBProvider
    
    private var pagesDict: [MediaCollection.Category: Int] = [:]
    
    public init(apiService: SeriesListApiService, provider: TMDBProvider) {
        self.apiService = apiService
        self.provider = provider
    }
    
    public func getNextPage(for category: MediaCollection.Category) async -> Result<MediaCollection, DomainError> {
        let nextPage = getAndUpdateNextPageIndex(for: category)
        let endpoint = apiService.buildEndpoint(
            with: .getPage(page: nextPage, category: category)
        )
        
        do {
            let response: PaginatedResponse<SerieResponse> = try await provider.getResponse(from: endpoint)
            guard
                let pageResults = response.results
            else { return .failure(.unknown) }
            
            let results = pageResults.compactMap {
                MediaItem(response: $0, category: .serie)
            }
            
            let totalPages = response.totalPages ?? .zero
            let hasMoreItems = totalPages > nextPage
            
            let collection = MediaCollection(
                category: category,
                items: results,
                hasMoreItems: hasMoreItems
            )
            
            return .success(collection)
        } catch {
            return .failure(.unknown)
        }
    }
    
    private func getAndUpdateNextPageIndex(for category: MediaCollection.Category) -> Int {
        let nextPage = pagesDict[category, default: 1]
        let newPage = nextPage + 1
        pagesDict[category] = newPage
        
        return nextPage
    }
}
