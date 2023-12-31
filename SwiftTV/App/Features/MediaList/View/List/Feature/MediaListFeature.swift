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
                return state.genres.isEmpty ? loadGenresEffect() : .none

            case let .section(id, action):
                switch action {
                case .onAppear:
                    return loadMediaEffect(state: &state, sectionId: id)
                case .onReachListEnd:
                    return loadMediaEffect(state: &state, sectionId: id)
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
                state.filters.items = genres.map { FilterItem(genre: $0) }
                return .none

            case let .filters(.onSetFilters(filters)):
                if filters.isEmpty { return reloadInitialSectionsEffect(state: &state) }

                let genreFilters: [MediaGenre] = filters.map { item in
                        .init(id: item.genre.id, name: item.genre.name)
                }

                let newGenres = genreFilters.filter { genre in
                    state.collectionStates.first(where: { $0.id == String(genre.id) }) == nil
                }

                let removedGenres = state.genres.filter { genre in
                    genreFilters.first(where: { $0.id == genre.id }) == nil
                }
                let sectionType: MediaSectionFeature.State.SectionType

                switch state.type {
                case .series: sectionType = .discovery
                case .movies: sectionType = .discovery
                }
                let sections = genreFilters.map { genre in
                    MediaSectionFeature.State(
                        collection: .init(
                            id: Mapping.toString.map(genre.id),
                            title: genre.name,
                            category: .series(.custom(genre.name)),
                            items: [],
                            hasMoreItems: true
                        ),
                        sectionType: sectionType
                    )
                }
                let newSections = newGenres.map { genre in
                    MediaSectionFeature.State(
                        collection: .init(
                            id: Mapping.toString.map(genre.id),
                            title: genre.name,
                            category: .series(.custom(genre.name)),
                            items: [],
                            hasMoreItems: true
                        ),
                        sectionType: sectionType
                    )
                }
                let removedSections = removedGenres.map { genre in
                    MediaSectionFeature.State(
                        collection: .init(
                            id: Mapping.toString.map(genre.id),
                            title: genre.genre.name,
                            category: .series(.custom(genre.genre.name)),
                            items: [],
                            hasMoreItems: true
                        ),
                        sectionType: sectionType
                    )
                }
                if newGenres.count == genreFilters.count {
                    state.collectionStates = .init(uniqueElements: sections)
                } else {

                    state.collectionStates.append(contentsOf: newSections)
                    removedSections.forEach {
                        state.collectionStates.remove($0)
                    }

                    state.collectionStates.sort(by: { $0.id < $1.id })
                }

                return .none
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

    private func loadGenresEffect() -> EffectOf<MediaListFeature> {
        .run { send in
            let genres = try await listClient.getAllGenres().get()
            await send(.onGenresLoaded(genres.map { MediaGenreItem(id: $0.id, name: $0.name) }))
        }
    }

    private func reloadInitialSectionsEffect(state: inout MediaListFeature.State) -> EffectOf<MediaListFeature> {
        let collections = state.type.builder
        let sectionType: MediaSectionFeature.State.SectionType = switch state.type {
        case .series:
            .tv
        case .movies:
            .movie
        }
        state.collectionStates = .init(
            uniqueElements: collections.map {
                MediaSectionFeature.State(
                    collection: .init(mediaCollection: $0),
                    sectionType: sectionType
                )
            }
        )
        return .none
    }

    private func loadMediaEffect(state: inout MediaListFeature.State, sectionId: MediaSectionFeature.State.ID) -> EffectOf<MediaListFeature> {
        guard var sectionState = state.collectionStates.first(where: { $0.id == sectionId }) else { return .none }

        let category = sectionState.collection.category
        let currentPage = sectionState.currentPage
        sectionState.currentPage += 1
        let genres = state.genres
        let sectionType = sectionState.sectionType
        let sectionId = sectionState.id
        state.collectionStates.updateOrAppend(sectionState)

        return .run { send in
            var results: MediaCollection?

            switch sectionType {
            case .discovery:
                if let sectionGenre = genres.first(where: { String($0.id) == sectionId }) {
                    results = try await getNextDiscoveryPage(page: currentPage, category: .tv, genres: [sectionGenre])
                }
            case .tv:
                results = try await getNextPage(page: currentPage, category: category)
            case .movie:
                results = try await getNextPage(page: currentPage, category: category)
            }

            if let results {
                await send(.section(id: sectionId, action: .onLoadCollection(results)))
            }
        }
    }

    private func getNextDiscoveryPage(page: Int, category: MediaItemCategory, genres: [FilterItem]) async throws -> MediaCollection? {
        let request = DiscoveryRequest(
            category: category,
            genres: genres.map { MediaGenre(id: $0.id, name: $0.genre.name) }
        )

        return try await listClient.getNextDiscoveryPage(page, request).get().last
    }

    private func getNextPage(page: Int, category: MediaCollection.Category) async throws -> MediaCollection? {
        try await listClient.getNextPage(page, category).get()
    }

}

// MARK: - State
extension MediaListFeature {
    struct State: FeatureState {
        let type: ListType
        var filters: ListFilterFeature.State = .init()
        var collectionStates: IdentifiedArrayOf<MediaSectionFeature.State> = []
        var genres: [FilterItem] = []

        var isFiltering: Bool {
            filters.isActive && filters.items.first(where: { $0.isSelected }) != nil
        }

        @PresentationState var selectedSerie: MediaDetailFeature.State?

        init() {
            type = .series
            let collections = type.builder
            collectionStates = .init(
                uniqueElements: collections.map {
                    MediaSectionFeature.State(
                        collection: .init(mediaCollection: $0),
                        sectionType: .tv
                    )
                }
            )
        }

        init(type: ListType) {
            self.type = type
            let collections = type.builder
            let sectionType: MediaSectionFeature.State.SectionType = switch type {
            case .series:
                .tv
            case .movies:
                .movie
            }
            collectionStates = .init(
                uniqueElements: collections.map {
                    MediaSectionFeature.State(
                        collection: .init(mediaCollection: $0),
                        sectionType: sectionType
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
