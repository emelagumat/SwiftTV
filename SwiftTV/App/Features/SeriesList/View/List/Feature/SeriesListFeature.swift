
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
            case let .section(stateId, action):
                switch action {
                case let .thumbnail(id, action):
                    if action == .onTap {
                        let section = state.collectionStates.first(where: {
                            $0.id == stateId
                        })
                        
                        let serie = state.collectionStates.flatMap(\.thumbnails).first(where: {
                            $0.id == id
                        })
                        
                        if let serie {
                            return .send(.onSelect(serie.item))
                        }
                    }
                default:
                    return .none
                }
                return .none
            case let .onSelect(serie):
                state.selectedSerie = .init(model: serie)
                return .none
            case let .selectedSerie(selectedSerie):
                return .none
            }
        }
        .forEach(\.collectionStates, action: /Action.section(id:action:)) {
            SerieSectionFeature()
        }
        .ifLet(\.$selectedSerie, action: /Action.selectedSerie) {
            SerieDetailFeature()
        }
    }
}

// MARK: - State
extension SeriesListFeature {
    struct State: FeatureState {
        var collectionStates: IdentifiedArrayOf<SerieSectionFeature.State> = []
        @PresentationState var selectedSerie: SerieDetailFeature.State?
        
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
        case onSelect(SerieModel)
        case selectedSerie(PresentationAction<SerieDetailFeature.Action>)
    }
}

protocol FeatureState: Equatable {
    init()
}

extension Store where State: FeatureState {
    convenience init<R: Reducer>(_ feature: R) where R.State == State, R.Action == Action {
        self.init(initialState: .init(), reducer: { feature })
    }
}
extension Reducer where State: FeatureState {
    
}
