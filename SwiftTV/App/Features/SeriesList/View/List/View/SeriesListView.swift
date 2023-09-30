
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
                        store.scope(
                            state: \.collectionStates,
                            action: SeriesListFeature.Action.section(id:action:)
                        ),
                        content: { sectionStore in
                            SerieSectionView(store: sectionStore)
                        }
                    )
                }
            }
            .padding()
            .task {
                viewStore.send(.onAppear)
            }
            .sheet(
                  store: self.store.scope(
                    state: \.$selectedSerie,
                    action: { .selectedSerie($0) }
                  )
                ) { detailStore in
                    SerieDetailView(store: detailStore)
                }
        }
    }
}

#Preview {
    SeriesListView(store: .init(SeriesListFeature())
    )
}
