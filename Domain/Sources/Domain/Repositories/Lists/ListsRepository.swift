
public protocol ListsRepository {
    func getNextPage(for category: MediaCollection.Category) async -> Result<MediaCollection, DomainError>
    func getAllGenres() async -> Result<[MediaGender], DomainError>
}
