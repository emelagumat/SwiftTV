public protocol ListsRepository {
    func getAllGenres() async -> Result<[MediaGenre], DomainError>
    func getNextPage(
        for category: MediaCollection.Category
    ) async -> Result<MediaCollection, DomainError>
    func getPage(
        _ page: Int,
        for category: MediaCollection.Category
    ) async -> Result<MediaCollection, DomainError>
    func getNextDiscoveryPage(for request: DiscoveryRequest) async -> Result<[MediaCollection], DomainError>
    func getDiscoveryPage(_ page: Int, for request: DiscoveryRequest) async -> Result<[MediaCollection], DomainError>
}
