
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
                filtersView(viewStore)
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEachStore(
                            store.scope(
                                state: \.collectionStates,
                                action: SeriesListFeature.Action.section(id:action:)
                            ),
                            content: { sectionStore in
                                SerieSectionView(store: sectionStore)
                                    .transition(.opacity)
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
    
    func filtersView(_ viewStore: ViewStore<SeriesListView.State, SeriesListFeature.Action>) -> some View {
        HStack {
            if isFiltersActive {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewStore.genres) { genre in
                            GenderCapsule(text: genre.genre.name)
                                .onTapGesture { viewStore.send(.onGenreTapped(genre)) }
                        }
                    }
                }
                .scrollIndicators(.never)
                .transition(
                    AsymmetricTransition(
                        insertion: .push(from: .trailing),
                        removal: .push(from: .leading)
                    )
                )
            } else {
                Spacer()
            }
            Image(systemName: isFiltersActive ? "x.circle" : "slider.horizontal.3")
                .font(.title3)
                .symbolEffect(.bounce, value: isFiltersActive)
                .animation(.easeInOut, value: isFiltersActive)
                .transition(.symbolEffect)
            
                .onTapGesture {
                    withAnimation {
                        isFiltersActive.toggle()
                    }
                }
        }
        .padding()//[.top, .horizontal])
    }
}

#Preview {
    SeriesListView(
        store: .init(
        SeriesListFeature()
    )
    )
}
