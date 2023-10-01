
import ComposableArchitecture
import Domain
import MLDCore
import Foundation

struct SeriesListFeature: Reducer {
    @Dependency(\.listClient) var listClient
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                Task { try? await listClient.getNextPage() }
                return .none
            case .section:
                return .none
            }
        }
        .forEach(\.collectionStates, action: /Action.section(id:action:)) {
            SerieSectionFeature()
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
