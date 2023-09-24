
public class DiscoverUseCase {
    private let discoverRepository: DiscoverRepository
    
    public init(discoverRepository: DiscoverRepository) {
        self.discoverRepository = discoverRepository
    }
    
    func getDiscovery() async {
        await discoverRepository.getDiscovery()
    }
}
