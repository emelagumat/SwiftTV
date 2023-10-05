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
                        store: store.scope(
                            state: \.filters,
                            action: SeriesListFeature.Action.filters
                        )
                    )
                    .foregroundStyle(.appText)
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
//                }
            }
            .scrollIndicators(.never)
            .navigationDestination(
                store: store.scope(
                    state: \.$selectedSerie,
                    action: SeriesListFeature.Action.selectedSerie
                ),
                destination: {
                    SerieDetailView(store: $0)
                }
            )
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
