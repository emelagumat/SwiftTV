import ComposableArchitecture
import SwiftUI

struct NetworkImage: View {
    let store: StoreOf<NetworkImageFeature>
    
    init(
        placeholder: Image = .init(uiImage: .init()),
        store: StoreOf<NetworkImageFeature>? = nil
    ) {
        self.store = store ?? .init(
            initialState: NetworkImageFeature.State(placeholder: placeholder, isLoading: false),
            reducer: { NetworkImageFeature() }
        )
    }

    var body: some View {
        WithViewStore(
            self.store,
            observe: NetworkImage.State.init,
            send: { (viewAction: Action) in viewAction.featureAction }
        ) { viewStore in
            (viewStore.image ?? viewStore.placeholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .redacted(reason: viewStore.isLoading ? .placeholder : [])
                .task { @MainActor in
                    viewStore.send(.onAppear)
                }
        }
    }
}

import Data
struct NetworkImageFeature: Reducer {
    private let loader: ImageLoader

    init(container: DomainDIContainer = .shared) {
        loader = container.imageLoader
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .onGetUrl(url):
                guard !state.hasBeenLoaded else { return .none }
                state.isLoading = true

                return .run { send in
                    let image = await loader.loadImage(with: url)
                    await send(.onLoaded(image))
                }
            case .onLoaded(let uiImage):
                state.isLoading = false
                state.hasBeenLoaded = true
                if let uiImage {
                    state.image = Image(uiImage: uiImage)
                }
                return .none
            }
        }
    }
}

// MARK: - State
extension NetworkImageFeature {
    struct State: Equatable, Identifiable {
        let id: UUID = .init()
        var image: Image?
        var placeholder: Image
        var isLoading: Bool
        var hasBeenLoaded: Bool = false
    }
}

// MARK: - Action
extension NetworkImageFeature {
    enum Action: Equatable {
        case onAppear
        case onGetUrl(String)
        case onLoaded(UIImage?)
    }
}

extension NetworkImage {
    struct State: Equatable {
        var image: Image?
        var placeholder: Image
        var isLoading: Bool

        init(feature: NetworkImageFeature.State) {
            self.init(
                image: feature.image,
                placeholder: feature.placeholder,
                isLoading: feature.isLoading
            )
        }

        init(image: Image? = nil, placeholder: Image, isLoading: Bool) {
            self.image = image
            self.placeholder = placeholder
            self.isLoading = isLoading
        }

    }

    enum Action {
        case onAppear
        case onLoaded(UIImage?)
    }
}

extension NetworkImage.Action {
    var featureAction: NetworkImageFeature.Action {
        switch self {
        case .onAppear:
            return .onAppear
        case .onLoaded(let uIImage):
            return .onLoaded(uIImage)
        }
    }
}
