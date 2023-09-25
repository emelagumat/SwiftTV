
import SwiftUI
import ComposableArchitecture

struct SeriesListView: View {
    let store: StoreOf<SeriesListFeature>
    
    var body: some View {
        WithViewStore(
            store,
            observe: SeriesListView.State.init
        ) { viewStore in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 32) {
                    ForEachStore(
                        store.scope(state: \.collectionStates, action: SeriesListFeature.Action.section(id:action:)),
                        content: { sectionStore in
                        SerieSectionView(store: sectionStore) }
                    )
                }
            }
            .task {
                viewStore.send(.onAppear)
            }
            .padding()
        }
    }
}
