
import ComposableArchitecture
import SwiftUI

struct MediaThumnailFeature: Reducer {
    let container: DomainDIContainer
    
    init(container: DomainDIContainer = .shared) {
        self.container = container
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.imageLoader, action: /Action.imageLoader) {
            NetworkImageFeature(container: container)
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                .send(.imageLoader(.onGetUrl(state.item.posterStringURL)))
            default:
                .none
            }
        }
    }
}

extension MediaThumnailFeature {
    struct State: Equatable, Identifiable {
        let id: UUID = .init()
        var item: SerieModel
        var imageLoader = NetworkImageFeature.State(
            placeholder: .init(uiImage: .init()),
            isLoading: false
        )
    }
}

extension MediaThumnailFeature {
    enum Action: Equatable {
        case onAppear
        case imageLoader(NetworkImageFeature.Action)
    }
}
