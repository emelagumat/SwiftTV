
import ComposableArchitecture
import SwiftUI
import MLDFeatures

struct SerieDetailView: View {
    let namespace: Namespace.ID
    let store: StoreOf<SerieDetailFeature>
    
    var body: some View {
        WithViewStore(
            store,
            observe: { $0 }
        ) { viewStore in
            RemoteImage(
                store: .init(
                    initialState: RemoteImageFeature.State(imageStringURL: viewStore.model.posterStringURL),
                    reducer: {
                        RemoteImageFeature()
                    }
                )
            )
        }
    }
}

#Preview {
    SerieDetailView(namespace: Namespace.mockId, store: .init(SerieDetailFeature()))
}


extension Namespace {
    static var mock: Namespace {
        .init()
    }
    
    static var mockId: Namespace.ID {
        Namespace.mock.wrappedValue
    }
}
