
public final class ListsUseCase {
    private let listsRepository: ListsRepository
    
    public init(listsRepository: ListsRepository) {
        self.listsRepository = listsRepository
    }
    
    public func getNextPage(for category: MediaCollection.Category) async -> Result<MediaCollection, DomainError> {
        await listsRepository.getNextPage(for: category)
    }
}
