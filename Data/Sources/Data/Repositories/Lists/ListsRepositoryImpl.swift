
import Domain

public actor ListsRepositoryImpl: ListsRepository {
    private let listApiService: SeriesListApiService
    private let genresApiService: GenresAPIService
    
    private let provider: TMDBProvider
    
    private var genres: [MediaGender] = []
    
    private var pagesDict: [MediaCollection.Category: Int] = [:]
    
    public init(listApiService: SeriesListApiService, genresApiService: GenresAPIService, provider: TMDBProvider) {
        self.listApiService = listApiService
        self.genresApiService = genresApiService
        self.provider = provider
    }
    
    public func getNextPage(for category: MediaCollection.Category) async -> Result<MediaCollection, DomainError> {
        if genres.isEmpty {
            let result = await getAllGenres()
            if case let .success(genres) = result {
                self.genres = genres
            }
        }
        let nextPage = getAndUpdateNextPageIndex(for: category)
        let endpoint = listApiService.buildEndpoint(
            with: .getPage(page: nextPage, category: category)
        )
        
        do {
            let response: PaginatedResponse<SerieResponse> = try await provider.getResponse(from: endpoint)
            guard
                let pageResults = response.results
            else { return .failure(.unknown) }
            
            let results = pageResults.compactMap {
                MediaItem(response: $0, category: .serie, genders: genres)
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
    
    public func getAllGenres() async -> Result<[MediaGender], DomainError> {
        guard
            genres.isEmpty
        else { return .success(genres) }
        
        let endpoint = genresApiService.buildEndpoint(with: .series)
        
        do {
            let response: GenresResponse = try await provider.getResponse(from: endpoint)
            let genres = response.genres.map { MediaGender(id: $0.id, name: $0.name) }
            return .success(genres)
        } catch {
            return .failure(.unknown)
        }
    }
}
