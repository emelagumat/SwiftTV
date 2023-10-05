import SwiftUI
import ComposableArchitecture

struct MediaListView: View {
    let store: StoreOf<MediaListFeature>
    @SwiftUI.State var isFiltersActive = false

    var body: some View {
        WithViewStore(
            store,
            observe: MediaListView.State.init
        ) { viewStore in
                VStack {
                    ListFilterView(
                        store: store.scope(
                            state: \.filters,
                            action: MediaListFeature.Action.filters
                        )
                    )
                    .foregroundStyle(.appText)
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 32) {
                            ForEachStore(
                                store.scope(
                                    state: \.collectionStates,
                                    action: MediaListFeature.Action.section(id:action:)
                                ),
                                content: { sectionStore in
                                    MediaSectionView(store: sectionStore)
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
                    action: MediaListFeature.Action.selectedSerie
                ),
                destination: {
                    MediaDetailView(store: $0)
                }
            )
        }
    }
}

#Preview {
    MediaListView(
        store: .init(
            MediaListFeature()
        )
    )
}
