import Domain

public actor ListsRepositoryImpl: ListsRepository {
    private let provider: TMDBProvider

    private let listApiService: ListApiService
    private let discoveryApiService: DiscoveryApiService
    private let genresApiService: GenresAPIService

    private var genres: [MediaGenre] = []
    private var pagesDict: [MediaCollection.Category: Int] = [:]
    private var discoveryPagesDict: [DiscoveryRequest: Int] = [:]

    public init(
        listApiService: ListApiService,
        discoveryApiService: DiscoveryApiService,
        genresApiService: GenresAPIService,
        provider: TMDBProvider
    ) {
        self.listApiService = listApiService
        self.discoveryApiService = discoveryApiService
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
            let response: PaginatedResponse<MediaResponse> = try await provider.getResponse(from: endpoint)

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

    public func getPage(_ page: Int, for category: MediaCollection.Category) async -> Result<MediaCollection, DomainError> {
        let endpoint = listApiService.buildEndpoint(
            with: .getPage(page: page, category: category)
        )

        do {
            let response: PaginatedResponse<MediaResponse> = try await provider.getResponse(from: endpoint)

            guard
                let pageResults = response.results
            else { return .failure(.unknown) }

            let totalPages = response.totalPages ?? .zero
            let hasMoreItems = totalPages > page

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

    public func getNextDiscoveryPage(for request: DiscoveryRequest) async -> Result<[MediaCollection], DomainError> {
        let nextPage = getAndUpdateNextDiscoveryPageIndex(for: request)
        let endpoint = discoveryApiService.buildEndpoint(
            with: .getPage(page: nextPage, request: request)
        )

        do {
            let response: PaginatedResponse<MediaResponse> = try await provider.getResponse(from: endpoint)

            guard
                let pageResults = response.results
            else { return .failure(.unknown) }

            let totalPages = response.totalPages ?? .zero
            let hasMoreItems = totalPages > nextPage

            let items = buildMediaItems(with: pageResults, category: request.category)

            let collections = request.genres.map {
                let category: MediaCollection.Category

                    switch request.category {
                    case .movie:
                            category = .movies(.custom($0.name))
                    case .tv:
                            category = .series(.custom($0.name))
                    }

                return MediaCollection(
                    category: category,
                    items: items,
                    hasMoreItems: hasMoreItems
                )
            }

            return .success(collections)
        } catch {
            return .failure(.unknown)
        }
    }

    public func getDiscoveryPage(_ page: Int, for request: DiscoveryRequest) async -> Result<[MediaCollection], DomainError> {
        let endpoint = discoveryApiService.buildEndpoint(
            with: .getPage(page: page, request: request)
        )

        do {
            let response: PaginatedResponse<MediaResponse> = try await provider.getResponse(from: endpoint)

            guard
                let pageResults = response.results
            else { return .failure(.unknown) }

            let totalPages = response.totalPages ?? .zero
            let hasMoreItems = totalPages > page

            let items = buildMediaItems(with: pageResults, category: request.category)

            let collections = request.genres.map {
                let category: MediaCollection.Category

                    switch request.category {
                    case .movie:
                            category = .movies(.custom($0.name))
                    case .tv:
                            category = .series(.custom($0.name))
                    }

                return MediaCollection(
                    category: category,
                    items: items,
                    hasMoreItems: hasMoreItems
                )
            }

            return .success(collections)
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

    private func getAndUpdateNextDiscoveryPageIndex(for request: DiscoveryRequest) -> Int {
        let nextPage = discoveryPagesDict[request, default: 1]
        let newPage = nextPage + 1
        discoveryPagesDict[request] = newPage

        return nextPage
    }

    private func buildCollection(
        from responses: [MediaResponse?],
        category: MediaCollection.Category,
        hasMoreItems: Bool
    ) -> MediaCollection {
        let results: [MediaItem]

        switch category {
        case .series:
            results = responses.compactMap {
                TVMediaItem(
                    response: $0,
                    category: .tv,
                    genres: genres
                )
            }
        case .movies:
            results = responses.compactMap {
                MovieMediaItem(
                    response: $0,
                    category: .movie,
                    genres: genres
                    )
            }
        }
//        let results = responses.compactMap {
//            MediaItem(response: $0, category: .serie, genres: genres)
//        }

        return MediaCollection(
            category: category,
            items: results,
            hasMoreItems: hasMoreItems
        )
    }

    private func buildMediaItems(with responses: [MediaResponse?], category: MediaItemCategory) -> [MediaItem] {
            let results: [MediaItem]

            switch category {
            case .tv:
                results = responses.compactMap {
                    TVMediaItem(
                        response: $0,
                        category: .tv,
                        genres: genres
                    )
                }
            case .movie:
                results = responses.compactMap {
                    MovieMediaItem(
                        response: $0,
                        category: .movie,
                        genres: genres
                        )
                }
            }

        return results
    }
}
