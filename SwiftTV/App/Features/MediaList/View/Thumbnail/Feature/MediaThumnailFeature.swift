import ComposableArchitecture
import SwiftUI
import MLDFeatures

struct MediaThumnailFeature: Reducer {
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                
                    return .send(.image(.onGetStringURL(state.item.posterStringURL)))
            case .image:
                return .none
            case .onTap:
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
        var id: String { item.id }
        var item: MediaItemModel
        var image = RemoteImageFeature.State()
    }
}

extension MediaThumnailFeature {
    enum Action: Equatable {
        case onAppear
        case onTap
        case image(RemoteImageFeature.Action)
    }
}
