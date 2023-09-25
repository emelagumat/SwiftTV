
import ComposableArchitecture
import Domain
import MLDCore

struct SeriesListFeature: Reducer {
    private let container: DomainDIContainer
    
    init(container: DomainDIContainer = .shared) {
        self.container = container
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
            case .section:
                return .none
            }
        }
        .forEach(\.collectionStates, action: /Action.section(id:action:)) {
            SerieSectionFeature(container: container)
        }
    }
}

// MARK: - State
extension SeriesListFeature {
    struct State: Equatable {
        var collectionStates: IdentifiedArrayOf<SerieSectionFeature.State> = []
        
        init() {
            let collections = MediaCollection.Category.Serie.allCases.map {
                MediaCollection(
                    category: .series($0),
                    items: [],
                    hasMoreItems: true
                )
            }
            collectionStates = .init(
                uniqueElements: collections.map {
                    SerieSectionFeature.State(
                        collection: .init(mediaCollection: $0)
                    )
                }
            )
            
        }
    }
}

// MARK: - Action
extension SeriesListFeature {
    enum Action: Equatable {
        case onAppear
        case section(id: SerieSectionFeature.State.ID, action: SerieSectionFeature.Action)
    }
}
