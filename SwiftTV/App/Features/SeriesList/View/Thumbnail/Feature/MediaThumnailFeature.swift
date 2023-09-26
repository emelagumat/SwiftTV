
import ComposableArchitecture
import SwiftUI
import RemoteImage

struct MediaThumnailFeature: Reducer {
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                    return .send(.image(.onGetStringURL(state.item.posterStringURL)))
            case let .image(image):
                return .none
            }
        }
        
        Scope(state: \.image, action: /Action.image) {
            RemoteImageFeature()
        }
    }
}

extension MediaThumnailFeature {
    struct State: Equatable, Identifiable {
        let id: UUID = .init()
        var item: SerieModel
        var image = RemoteImageFeature.State()
    }
}

extension MediaThumnailFeature {
    enum Action: Equatable {
        case onAppear
        case image(RemoteImageFeature.Action)
    }
}
