import ComposableArchitecture
import Domain
import MLDCore
import Foundation

struct MediaListFeature: Reducer {
    @Dependency(\.listClient) var listClient

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                if state.genres.isEmpty {
                    return .run { send in
                        let genres = try await listClient.getAllGenres().get()
                        await send(.onGenresLoaded(genres.map { MediaGenreItem(id: $0.id, name: $0.name) }))
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
                state.filters.items = genres.map { FilterItem(genre: $0) }
                return .none

            case let .filters(.onSetFilters(filters)):
                let genreFilters: [MediaGenre] = filters.map { item in
                        .init(id: item.genre.id, name: item.genre.name)
                }
                let sections = genreFilters.map { genre in
                    MediaSectionFeature.State(
                        collection: .init(
                            id: String(genre.id),
                            title: String(genre.id),
                            category: .series(.custom(genre.name)),
                            items: [],
                            hasMoreItems: true
                        ),
                        filters: [genre]
                    )
                }
                state.collectionStates = .init(uniqueElements: sections)
                let allSectionsActions = genreFilters.map { genre in
                    MediaListFeature.Action.section(
                        id: genre.name,
                        action: .onSetFilters([genre])
                    )
                }
                
                return .merge(allSectionsActions.map { .send($0) })
            case .filters:
                return .none
            }
        }
        .forEach(\.collectionStates, action: /Action.section(id:action:)) {

            MediaSectionFeature()
                .dependency(\.listClient, listClient)
        }
        .ifLet(\.$selectedSerie, action: /Action.selectedSerie) {
            MediaDetailFeature()
                .dependency(\.listClient, listClient)
        }
        Scope(state: \.filters, action: /Action.filters) {
            ListFilterFeature()
        }
    }
}

// MARK: - State
extension MediaListFeature {
    struct State: FeatureState {
        let type: ListType
        var filters: ListFilterFeature.State = .init()
        var collectionStates: IdentifiedArrayOf<MediaSectionFeature.State> = []
        var genres: [FilterItem] = []

        @PresentationState var selectedSerie: MediaDetailFeature.State?

        init() {
            type = .series
            let collections = type.builder
            collectionStates = .init(
                uniqueElements: collections.map {
                    MediaSectionFeature.State(
                        collection: .init(mediaCollection: $0),
                        filters: []
                    )
                }
            )
        }

        init(type: ListType) {
            self.type = type
            let collections = type.builder
            collectionStates = .init(
                uniqueElements: collections.map {
                    MediaSectionFeature.State(
                        collection: .init(mediaCollection: $0),
                        filters: []
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
extension MediaListFeature {
    enum Action: Equatable {
        case onAppear
        case section(id: MediaSectionFeature.State.ID, action: MediaSectionFeature.Action)
        case onSelect(MediaItemModel)
        case selectedSerie(PresentationAction<MediaDetailFeature.Action>)
        case onGenresLoaded([MediaGenreItem])
        case filters(ListFilterFeature.Action)
    }
}
