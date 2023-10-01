
import ComposableArchitecture
import Foundation
import Domain

struct SerieSectionFeature: Reducer {
    let container: DomainDIContainer
    
    init(container: DomainDIContainer = .shared) {
        self.container = container
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let category = state.collection.category
                if state.collection.items.isEmpty {
                    return .run { send in
                        let results = await container.listUseCase.getNextPage(for: .series(category))
                        if case let .success(success) = results {
                            await send(.onLoadCollection(success))
                        }
                    }
                } else { return .none }
            case let .onLoadCollection(collection):
                state.update(with: collection)
                return .none
            case .thumbnail:
                return .none
            case .onReachListEnd:
                guard
                    !state.thumbnails.isEmpty
                else { return .none }
                
                let category = state.collection.category
                return .run { send in
                    let results = await container.listUseCase.getNextPage(for: .series(category))
                    if case let .success(success) = results {
                        await send(.onLoadCollection(success))
                    }
                }
            }
        }
        .forEach(\.thumbnails, action: /Action.thumbnail(id:action:)) {
            MediaThumnailFeature()
        }
    }
}

extension SerieSectionFeature {
    struct State: Equatable, Identifiable {
        let id: UUID
        var collection: SerieCollection
        var thumbnails: IdentifiedArrayOf<MediaThumnailFeature.State> = []
        
        init() {
            self.id = .init()
            self.collection = .init(
                id: UUID().uuidString,
                title: "",
                category: .popular,
                items: []
            )
        }
        
        init(collection: SerieCollection) {
            self.id = .init()
            self.collection = collection
            self.thumbnails = .init(uniqueElements: collection.items.map { MediaThumnailFeature.State(item: $0) })
        }
        
        mutating func update(with collection: MediaCollection) {
            let newItems =  collection.items.map {
                SerieModel(
                    id: String($0.id),
                    name: $0.name,
                    overview: $0.overview,
                    backdropStringURL: $0.backdropURL,
                    posterStringURL: $0.posterURL,
                    genders: $0.genres.map { SerieGender(id: $0.id, name: $0.name) },
                    rate: .init($0.rate)
                )
            }
                .filter { model in !self.collection.items.contains(where: { $0.id == model.id })}
            
            self.collection = .init(
                id: self.collection.id,
                title: collection.category.displayName,
                category: self.collection.category,
                items: self.collection.items + newItems
            )
            self.thumbnails = .init(uniqueElements: self.collection.items.map { MediaThumnailFeature.State(item: $0) })
        }
    }
}

extension SerieSectionFeature {
    enum Action: Equatable {
        case onAppear
        case onLoadCollection(MediaCollection)
        case thumbnail(id: MediaThumnailFeature.State.ID, action: MediaThumnailFeature.Action)
        case onReachListEnd
    }
}
