
import ComposableArchitecture
import Domain
import MLDCore

struct SeriesListFeature: Reducer {
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                let allCollections = state.collections
                return .run { send in
                    let firstPages = await allCollections.asyncMap {
                        let useCase = DomainDIContainer.shared.listUseCase
                        async let value = useCase.getNextPage(for: $0.category)
                        return await value
                    }
                    
                    let values = firstPages.compactMap { result in
                        if case let .success(value) = result {
                            return value
                        }
                        return nil
                    }
                    await send(.onLoadedCollections(values))
                }
            case let .onLoadedCollection(collection):
                state.update(with: collection)
                return .none
            case let .onLoadedCollections(collections):
                return .concatenate(collections.map { .send(.onLoadedCollection($0)) })
            }
        }
    }
}


extension Result {}
extension SeriesListFeature {
    struct State: Equatable {
        var collections: [MediaCollection] = []
        
        init() {
            collections = MediaCollection.Category.Serie.allCases.map {
                MediaCollection(
                    category: .series($0),
                    items: [],
                    hasMoreItems: true
                )
            }
        }
        
        mutating func update(with collection: MediaCollection) {
            guard
                let currentCollectionIndex = collections.firstIndex(of: collection),
                var currentCollection = collections.first(where: { $0.category == collection.category})
            else {
                collections.append(collection)
                return
            }
            currentCollection.addItems(collection.items, hasMore: collection.hasMoreItems)
            collections[currentCollectionIndex] = currentCollection
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case onLoadedCollection(MediaCollection)
        case onLoadedCollections([MediaCollection])
    }
}
