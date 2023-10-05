import ComposableArchitecture
import Foundation
import Domain

struct MediaSectionFeature: Reducer {
    @Dependency(\.listClient)
    var listClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.thumbnails.isEmpty {
                    let category = state.collection.category
                    return .run { send in
                        _ = await listClient.getAllGenres()
                        let results = try await listClient.getNextPage(category)
                        if case let .success(success) = results {
                            await send(.onLoadCollection(success))
                        }
                    }
                } else {
                    return .none
                }
            case let .onLoadCollection(collection):
                state.update(with: collection)
                if state.thumbnails.isEmpty {
                    return .send(.onReachListEnd)
                }
                return .none
            case .thumbnail:
                return .none
            case .onReachListEnd:
                let category = state.collection.category
                return .run { send in
                    let results = try await listClient.getNextPage(category)
                    if case let .success(success) = results {
                        await send(.onLoadCollection(success))
                    }
                }
            case let .onSetFilters(genres):
                state.filters = genres
                if state.thumbnails.isEmpty {
                    return .send(.onReachListEnd)
                }
                return .none
            }
        }
        .forEach(\.thumbnails, action: /Action.thumbnail(id:action:)) {
            MediaThumnailFeature()
        }
    }
}

extension MediaSectionFeature {
    struct State: Equatable, Identifiable {
        let id: UUID
        var collection: MediaItemCollection {
            didSet {
                updateWithFilters()
            }
        }
        var filters: [MediaGenre] = [] {
            didSet {
                updateWithFilters()
            }
        }

        private var _thumbnails: [MediaThumnailFeature.State] = []
        var thumbnails: IdentifiedArrayOf<MediaThumnailFeature.State> = []

        init() {
            self.id = .init()
            self.collection = .init(
                id: UUID().uuidString,
                title: "",
                category: .series(.popular),
                items: []
            )
        }

        init(collection: MediaItemCollection) {
            self.id = .init()
            self.collection = collection
            self.thumbnails = .init(uniqueElements: collection.items.map { MediaThumnailFeature.State(item: $0) })
        }

        mutating func update(with collection: MediaCollection) {
            let newItems =  collection.items.map {
                let tvMedia = $0 as? TVMediaItem
                let movieMedia = $0 as? MovieMediaItem

                return MediaItemModel(
                    id: String($0.id),
                    name: tvMedia?.name ?? movieMedia?.title ?? "",
                    overview: tvMedia?.overview ?? movieMedia?.overview ?? "",
                    backdropStringURL: $0.backdropURL,
                    posterStringURL: $0.posterURL,
                    genres: $0.genres.map { MediaGenreItem(id: $0.id, name: $0.name) },
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
        }

        private mutating func updateWithFilters() {
            var thumbailsItems = collection.items
            if !filters.isEmpty {
                thumbailsItems = thumbailsItems.filter {
                    let thumbnailGenres = $0.genres.map { MediaGenre(id: $0.id, name: $0.name) }
                    let containsAny = !thumbnailGenres.filter { filters.contains($0) }.isEmpty
                    return containsAny
                }
            }
            self.thumbnails = .init(uniqueElements: thumbailsItems.map {
                MediaThumnailFeature.State(item: $0)
            })
        }
    }
}

extension MediaSectionFeature {
    enum Action: Equatable {
        case onAppear
        case onLoadCollection(MediaCollection)
        case thumbnail(id: MediaThumnailFeature.State.ID, action: MediaThumnailFeature.Action)
        case onReachListEnd
        case onSetFilters([MediaGenre])
    }
}
