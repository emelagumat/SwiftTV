
import SwiftUI
import ComposableArchitecture

struct SeriesListView: View {
    let store: StoreOf<SeriesListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Hello store")
                .onAppear(perform: {
                    viewStore.send(.onAppear)
                })
        }
    }
}

#Preview {
    SeriesListView(store: .init(initialState: .init(), reducer: SeriesListFeature.init))
}
