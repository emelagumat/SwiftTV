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
                    return .none
            case let .onLoadCollection(collection):
                state.update(with: collection)
                return .none
            case .thumbnail:
                return .none
            case .onReachListEnd:
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
        let sectionType: SectionType
        let id: String
        var currentPage = 1
        var collection: MediaItemCollection
        
        var thumbnails: IdentifiedArrayOf<MediaThumnailFeature.State> = []
        
        init() {
            self.sectionType = .tv
            self.id = .init()
            self.collection = .init(
                id: UUID().uuidString,
                title: "",
                category: .series(.popular),
                items: [],
                hasMoreItems: true
            )
        }
        
        init(collection: MediaItemCollection, sectionType: SectionType) {
            self.sectionType = sectionType
            self.id = collection.id
            self.collection = collection
            updateThumnbails()
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
            updateThumnbails()
        }
        
        private mutating func updateThumnbails() {
            self.thumbnails = .init(uniqueElements: collection.items.map {
                MediaThumnailFeature.State(item: $0) })
        }
        
        enum SectionType: Equatable {
            case tv
            case movie
            case discovery
        }
    }
}

extension MediaSectionFeature {
    enum Action: Equatable {
        case onAppear
        case onLoadCollection(MediaCollection)
        case thumbnail(id: MediaThumnailFeature.State.ID, action: MediaThumnailFeature.Action)
        case onReachListEnd
    }
}
