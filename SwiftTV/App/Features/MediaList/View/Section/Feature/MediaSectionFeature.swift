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
                    if state.filters.isEmpty {
                        let category = state.collection.category
                        let currentPage = state.currentPage
                        state.currentPage += 1
                        return .run { send in
                            _ = await listClient.getAllGenres()
                            let results = try await listClient.getNextPage(currentPage, category)
                            if case let .success(success) = results {
                                await send(.onLoadCollection(success))
                            }
                        }
                    } else {
                        let genres = state.filters
                        let currentPage = state.currentPage
                        state.currentPage += 1
                        
                        return .merge(
                            genres.map { genre in
                                Effect.run { send in
                                    let results = try await listClient.getNextDiscoveryPage(currentPage, DiscoveryRequest(category: .movie, genres: [genre]))
                                    if case let .success(success) = results, let section = success.first {
                                        
                                        await send(.onLoadCollection(section))
                                    }
                                    
                                }
                            }
                        )
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
                if state.filters.isEmpty {
                    let category = state.collection.category
                    let currentPage = state.currentPage
                    state.currentPage += 1
                    return .run { send in
                        let results = try await listClient.getNextPage(currentPage, category)
                        if case let .success(success) = results {
                            await send(.onLoadCollection(success))
                        }
                    }
                } else {
                    let genres = state.filters
                    if state.collection.hasMoreItems {
                        let currentPage = state.currentPage
                        state.currentPage += 1
                        return .merge(
                            genres.map { genre in
                                Effect.run { send in
                                    let results = try await listClient.getNextDiscoveryPage(currentPage, DiscoveryRequest(category: .movie, genres: [genre]))
                                    if case let .success(success) = results, let section = success.first {
                                        
                                        await send(.onLoadCollection(section))
                                    }
                                    
                                }
                            }
                        )
                    } else {
                        let mec = state.thumbnails.map {
                            MediaSectionFeature.Action.thumbnail(
                                id: $0.id,
                                action: .image(.onLoaded(nil))
                            )
                        }
                        return .merge(mec.map { .send($0) })
                    }
                }
            case let .onSetFilters(genres):
//                state.filters = genres
//                if !genres.isEmpty {
//                    return .merge(
//                        genres.map { genre in
//                            Effect.run(operation: { send in
//                                let results = try await listClient.getNextDiscoveryPage(DiscoveryRequest(category: .movie, genres: [genre]))
//                                if case let .success(success) = results, let section = success.first {
//                                    
//                                    await send(.onLoadCollection(section))
//                                }
//                            }, catch: {
//                                print($0)
//                                print($1)
//                            })
//                        }
//                    )
//                }
//                if state.thumbnails.isEmpty {
//                    return .send(.onReachListEnd)
//                }
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
        let id: String
        var currentPage = 1
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
                items: [],
                hasMoreItems: true
            )
        }
        
        init(collection: MediaItemCollection, filters: [MediaGenre]) {
            self.id = collection.id
            self.collection = collection
            self.filters = filters
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
                items: self.collection.items + newItems,
                hasMoreItems: collection.hasMoreItems
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
