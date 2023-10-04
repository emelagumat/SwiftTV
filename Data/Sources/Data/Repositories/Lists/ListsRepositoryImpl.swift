import Domain

public actor ListsRepositoryImpl: ListsRepository {
    private let provider: TMDBProvider

    private let listApiService: ListApiService
    private let genresApiService: GenresAPIService

    private var genres: [MediaGenre] = []
    private var pagesDict: [MediaCollection.Category: Int] = [:]

    public init(
        listApiService: ListApiService,
        genresApiService: GenresAPIService,
        provider: TMDBProvider
    ) {
        self.listApiService = listApiService
        self.genresApiService = genresApiService
        self.provider = provider
    }

    public func getNextPage(
        for category: MediaCollection.Category
    ) async -> Result<MediaCollection, DomainError> {
        let nextPage = getAndUpdateNextPageIndex(for: category)
        let endpoint = listApiService.buildEndpoint(
            with: .getPage(page: nextPage, category: category)
        )

        do {
            let response: PaginatedResponse<SerieResponse> = try await provider.getResponse(from: endpoint)

            guard
                let pageResults = response.results
            else { return .failure(.unknown) }

            let totalPages = response.totalPages ?? .zero
            let hasMoreItems = totalPages > nextPage

            let collection = buildCollection(
                from: pageResults,
                category: category,
                hasMoreItems: hasMoreItems
            )

            return .success(collection)
        } catch {
            return .failure(.unknown)
        }
    }

    public func getAllGenres() async -> Result<[MediaGenre], DomainError> {
        guard
            genres.isEmpty
        else { return .success(genres) }

        let endpoint = genresApiService.buildEndpoint(with: .series)

        do {
            let response: GenresResponse = try await provider.getResponse(from: endpoint)
            let genres = response.genres.map { MediaGenre(id: $0.id, name: $0.name) }
            self.genres = genres
            return .success(genres)
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

    private func buildCollection(
        from responses: [SerieResponse?],
        category: MediaCollection.Category,
        hasMoreItems: Bool
    ) -> MediaCollection {
        let results = responses.compactMap {
            MediaItem(response: $0, category: .serie, genres: genres)
        }

        return MediaCollection(
            category: category,
            items: results,
            hasMoreItems: hasMoreItems
        )
    }
}
