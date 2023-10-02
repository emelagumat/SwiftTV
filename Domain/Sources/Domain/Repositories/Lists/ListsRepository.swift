public protocol ListsRepository {
    func getAllGenres() async -> Result<[MediaGenre], DomainError>
    func getNextPage(
        for category: MediaCollection.Category
    ) async -> Result<MediaCollection, DomainError>
}
