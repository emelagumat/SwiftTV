public final class ListsUseCase {
    private let listsRepository: ListsRepository

    public init(listsRepository: ListsRepository) {
        self.listsRepository = listsRepository
    }

    public func getPage(
        _ page: Int,
        for category: MediaCollection.Category
    ) async -> Result<MediaCollection, DomainError> {
        await listsRepository.getPage(page, for: category)
    }

    public func getDiscoveryPage(_ page: Int, for request: DiscoveryRequest) async -> Result<[MediaCollection], DomainError> {
        await listsRepository.getDiscoveryPage(page, for: request)
    }

    public func getAllGenres() async -> Result<[MediaGenre], DomainError> {
        await listsRepository.getAllGenres()
    }
}
