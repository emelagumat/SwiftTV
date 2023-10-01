import SwiftUI
import ComposableArchitecture

struct SeriesListView: View {
    let store: StoreOf<SeriesListFeature>
    @SwiftUI.State var isFiltersActive = false

    var body: some View {
        WithViewStore(
            store,
            observe: SeriesListView.State.init
        ) { viewStore in
            VStack {
                ListFilterView(
                    isActive: $isFiltersActive,
                    items: viewStore.genres
                )
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
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    SeriesListView(
        store: .init(
        SeriesListFeature()
    )
    )
}
