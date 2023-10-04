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
                if state.genres.isEmpty {
                    return .run { send in
                        let genres = try await listClient.getAllGenres().get()
                        await send(.onGenresLoaded(genres.map { SerieGenre(id: $0.id, name: $0.name) }))
                    }
                } else {
                    return .none
                }

            case let .section(_, action):
                switch action {
                case let .thumbnail(id, action):
                    if action == .onTap {
                        if let serie = state.collectionStates.flatMap(\.thumbnails).first(where: {
                            $0.id == id
                        }) {
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

            case .selectedSerie:
                return .none

            case let .onGenresLoaded(genres):
                state.genres = genres.map { FilterItem(genre: $0) }
                return .none

            case var .onGenreTapped(genre):
                if let index = state.genres.firstIndex(of: genre) {
                    genre.isSelected.toggle()
                    state.genres[index] = genre
                }
                return .none
            }
        }
        .forEach(\.collectionStates, action: /Action.section(id:action:)) {

            SerieSectionFeature()
                .dependency(\.listClient, listClient)
        }
        .ifLet(\.$selectedSerie, action: /Action.selectedSerie) {
            SerieDetailFeature()
                .dependency(\.listClient, listClient)
        }
    }
}

// MARK: - State
extension SeriesListFeature {
    struct State: FeatureState {
        let type: ListType
        var collectionStates: IdentifiedArrayOf<SerieSectionFeature.State> = []
        var genres: [FilterItem] = []

        @PresentationState var selectedSerie: SerieDetailFeature.State?

        init() {
            type = .series
            let collections = type.builder
            collectionStates = .init(
                uniqueElements: collections.map {
                    SerieSectionFeature.State(
                        collection: .init(mediaCollection: $0)
                    )
                }
            )
        }

        init(type: ListType) {
            self.type = type
            let collections = type.builder
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

enum ListType {
    case series
    case movies

    var builder: [MediaCollection] {
        switch self {
        case .series:
            MediaCollection.Category.Serie.allCases.map {
                MediaCollection(
                    category: .series($0),
                    items: [],
                    hasMoreItems: true
                )
            }
        case .movies:
            MediaCollection.Category.Movie.allCases.map {
                MediaCollection(
                    category: .movies($0),
                    items: [],
                    hasMoreItems: true
                )
            }
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
        case onGenresLoaded([SerieGenre])
        case onGenreTapped(FilterItem)
    }
}
