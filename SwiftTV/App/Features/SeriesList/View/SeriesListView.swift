
import SwiftUI
import ComposableArchitecture

struct SeriesListView: View {
    let store: StoreOf<SeriesListFeature>
    
    var body: some View {
        WithViewStore(
            store,
            observe: SeriesListView.State.init
        ) { viewStore in
            Text("Hello parsed store")
                .onAppear { viewStore.send(.onAppear) }
        }
    }
}

#Preview {
    SeriesListView(store: .init(initialState: .init(), reducer: SeriesListFeature.init))
}
